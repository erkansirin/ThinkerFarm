//
//  HelpView.swift
//  ThinkerFarmExample
//
//  Created by Erkan SIRIN on 21.11.2019.
//  Copyright © 2019 Erkan SIRIN. All rights reserved.
//

import UIKit
import WebKit
class HelpView: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.load(URLRequest(url: URL(string: "http://thinkerfarm.com")!))
    }

    
    @IBAction func backAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
