//
//  CameraFeedManager.swift
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 9.11.2019.
//  Copyright © 2019 Thinker Farm. All rights reserved.
//


import UIKit
import AVFoundation

protocol CameraFeedManagerDelegate: class {
    
    func didOutput(pixelBuffer: CVPixelBuffer)
    
    func presentCameraPermissionsDeniedAlert()
    
    func presentVideoConfigurationErrorAlert()
    
    func sessionRunTimeErrorOccured()
    
    func sessionWasInterrupted(canResumeManually resumeManually: Bool)
    
    func sessionInterruptionEnded()
    
}

enum CameraConfiguration {
    
    case success
    case failed
    case permissionDenied
}


class CameraFeedManager: NSObject {
    
    let session: AVCaptureSession = AVCaptureSession()
    let previewView: PreviewView
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private var cameraConfiguration: CameraConfiguration = .failed
    lazy var videoDataOutput = AVCaptureVideoDataOutput()
    private var isSessionRunning = false
    var camera  = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    
    weak var delegate: CameraFeedManagerDelegate?
    
    init(previewView: PreviewView) {
        self.previewView = previewView
        super.init()
        
        session.sessionPreset = .high
        
        self.previewView.session = session
        
        
        
        self.previewView.previewLayer.connection?.videoOrientation = .landscapeLeft
        self.previewView.previewLayer.videoGravity = .resizeAspectFill
        self.attemptToConfigureSession()
    }
    
    
    func checkCameraConfigurationAndStartSession() {
        sessionQueue.async {
            switch self.cameraConfiguration {
            case .success:
                self.addObservers()
                self.startSession()
            case .failed:
                DispatchQueue.main.async {
                    self.delegate?.presentVideoConfigurationErrorAlert()
                }
            case .permissionDenied:
                DispatchQueue.main.async {
                    self.delegate?.presentCameraPermissionsDeniedAlert()
                }
            }
        }
    }
    
    func stopSession() {
        self.removeObservers()
        sessionQueue.async {
            if self.session.isRunning {
                self.session.stopRunning()
                self.isSessionRunning = self.session.isRunning
            }
        }
        
    }
    
    func resumeInterruptedSession(withCompletion completion: @escaping (Bool) -> ()) {
        
        sessionQueue.async {
            self.startSession()
            
            DispatchQueue.main.async {
                completion(self.isSessionRunning)
            }
        }
    }
    
    func startSession() {
        self.session.startRunning()
        self.isSessionRunning = self.session.isRunning
        
        
        
        
    }
    
    func attemptToConfigureSession() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.cameraConfiguration = .success
        case .notDetermined:
            self.sessionQueue.suspend()
            self.requestCameraAccess(completion: { (granted) in
                self.sessionQueue.resume()
            })
        case .denied:
            self.cameraConfiguration = .permissionDenied
        default:
            break
        }
        
        self.sessionQueue.async {
            self.configureSession()
        }
    }
    
    private func requestCameraAccess(completion: @escaping (Bool) -> ()) {
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            if !granted {
                self.cameraConfiguration = .permissionDenied
            }
            else {
                self.cameraConfiguration = .success
            }
            completion(granted)
        }
    }
    
    func configureSession() {
        
        guard cameraConfiguration == .success else {
            return
        }
        session.beginConfiguration()
        
        guard addVideoDeviceInput() == true else {
            self.session.commitConfiguration()
            self.cameraConfiguration = .failed
            return
        }
        
        guard addVideoDataOutput() else {
            self.session.commitConfiguration()
            self.cameraConfiguration = .failed
            return
        }
        
        session.commitConfiguration()
        self.cameraConfiguration = .success
    }
    
    
    private func addVideoDeviceInput() -> Bool {
        
        do {
            let videoDeviceInput = try AVCaptureDeviceInput(device: camera!)
            if session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
                return true
            }
            else {
                return false
            }
        }
        catch {
            fatalError("Cannot create video device input")
        }
    }
    
    private func addVideoDataOutput() -> Bool {
        
        let sampleBufferQueue = DispatchQueue(label: "sampleBufferQueue")
        videoDataOutput.setSampleBufferDelegate(self, queue: sampleBufferQueue)
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        videoDataOutput.videoSettings = [ String(kCVPixelBufferPixelFormatTypeKey) : kCMPixelFormat_32BGRA]
        
        if session.canAddOutput(videoDataOutput) {
            session.addOutput(videoDataOutput)
            
            videoDataOutput.connection(with: .video)?.videoOrientation = .portrait
            
            return true
        }
        return false
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(CameraFeedManager.sessionRuntimeErrorOccured(notification:)), name: NSNotification.Name.AVCaptureSessionRuntimeError, object: session)
        NotificationCenter.default.addObserver(self, selector: #selector(CameraFeedManager.sessionWasInterrupted(notification:)), name: NSNotification.Name.AVCaptureSessionWasInterrupted, object: session)
        NotificationCenter.default.addObserver(self, selector: #selector(CameraFeedManager.sessionInterruptionEnded), name: NSNotification.Name.AVCaptureSessionInterruptionEnded, object: session)
        
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVCaptureSessionRuntimeError, object: session)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVCaptureSessionWasInterrupted, object: session)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVCaptureSessionInterruptionEnded, object: session)
    }
    
    // MARK: Notification Observers
    @objc func sessionWasInterrupted(notification: Notification) {
        
        if let userInfoValue = notification.userInfo?[AVCaptureSessionInterruptionReasonKey] as AnyObject?,
            let reasonIntegerValue = userInfoValue.integerValue,
            let reason = AVCaptureSession.InterruptionReason(rawValue: reasonIntegerValue) {
            print("Capture session was interrupted with reason \(reason)")
            
            var canResumeManually = false
            if reason == .videoDeviceInUseByAnotherClient {
                canResumeManually = true
            } else if reason == .videoDeviceNotAvailableWithMultipleForegroundApps {
                canResumeManually = false
            }
            
            self.delegate?.sessionWasInterrupted(canResumeManually: canResumeManually)
            
        }
    }
    
    @objc func sessionInterruptionEnded(notification: Notification) {
        
        self.delegate?.sessionInterruptionEnded()
    }
    
    @objc func sessionRuntimeErrorOccured(notification: Notification) {
        guard let error = notification.userInfo?[AVCaptureSessionErrorKey] as? AVError else {
            return
        }
        
        print("Capture session runtime error: \(error)")
        
        if error.code == .mediaServicesWereReset {
            sessionQueue.async {
                if self.isSessionRunning {
                    self.startSession()
                } else {
                    DispatchQueue.main.async {
                        self.delegate?.sessionRunTimeErrorOccured()
                    }
                }
            }
        } else {
            self.delegate?.sessionRunTimeErrorOccured()
            
        }
    }
}

extension CameraFeedManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        let pixelBuffer: CVPixelBuffer? = CMSampleBufferGetImageBuffer(sampleBuffer)
        
        guard let imagePixelBuffer = pixelBuffer else {
            return
        }
        
        delegate?.didOutput(pixelBuffer: imagePixelBuffer)
    }
    
}

