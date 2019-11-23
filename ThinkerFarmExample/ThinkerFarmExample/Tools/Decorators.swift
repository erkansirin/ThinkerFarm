//
//  Decorators.swift
//  FullTrip
//
//  Created by Erkan SIRIN on 17.01.2018.
//  Copyright © 2018 Solid ICT. All rights reserved.
//

import Foundation
import UIKit




extension UIView {
    @IBInspectable var CornerRadius: CGFloat {
        get {
            return layer.cornerRadius+UIDecorators.UIViewRadious
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    
    @IBInspectable var CornerWidth: CGFloat {
        get {
            return UIDecorators.UIViewRadious
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
            layer.shadowColor = UIColor.black.cgColor
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    

    
      /*
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = shadowOpacity
            
        }
    }
    
  
    
    
    
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            let color = UIColor(cgColor: layer.shadowColor!)
            return color
        }
        set {
            layer.shadowColor =  UIColor.black.cgColor
        }
    }*/
}


struct UIDateTypes {
    static let flightDateType : String = "yyyy-MM-dd"
    static let flighLoadingDateTypes : String = "dd MMM yyyy"
    static let flighRulesDateTypes : String = "dd MMM EEEE yyyy"
    static let flighlistDateTypes : String = "dd MMM"
}


struct UIDecorators {
    
    
    
    static let ProjectFontBold=UIFont(name: "OpenSans-Bold", size: 14)
    static let ProjectFont=UIFont(name: "OpenSans", size: 14)
    static let ProjectFontSemiBold=UIFont(name: "OpenSans-SemiBold", size: 12)
    
    
    static let viewBorderWidth: CGFloat = 2
    static let UIViewRadious: CGFloat = 18
    static let UIButtonRadious: CGFloat = 5
    static let screenSize = UIScreen.main.bounds
    static let buttonRadious: CGFloat = 15
    static let buttonSmallRadious: CGFloat = 10
    static let bigButtonRadious: CGFloat = 25
    static let notificationButtonRadious: CGFloat = 5
    static let userFaceButtonRadious: CGFloat = 37
    static let mapViewHight: CGFloat = 455
    static let buttonBorder: CGFloat = 15
    static let formCellHeight : CGFloat = 60
    static let headerAnimationSpeed : TimeInterval = 1.0
    
    static let colorPastelRed1 = UIColor(red: 204/255, green: 50/255, blue: 75/255, alpha: 1.0)
    static let colorCodeOrange = UIColor(red: 255/255, green: 180/255, blue: 0/255, alpha: 1.0)
    static let colorCodeGray = UIColor(red: 103/255, green: 103/255, blue: 103/255, alpha: 1.0)
    static let colorCodeDarkGray = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
    static let colorCodeLightGray = UIColor(red: 161/255, green: 161/255, blue: 161/255, alpha: 1.0)
    static let colorCodeLightGrayWithOpacty = UIColor(red: 226/255, green: 220/255, blue: 217/255, alpha: 1.0)
    static let colorCodeLightGrayWithOpacty2 = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1.0)
    static let colorCodeUltraLightGray = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
    static let colorCodeUltraVeryLightGray = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1.0)
    static let colorCodeWhite = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    static let colorCodeBlue = UIColor(red: 46/255, green: 216/255, blue: 255/255, alpha: 1.0)
    static let borderColor = UIColor(red: 188/255, green: 187/255, blue: 187/255, alpha: 1.0)
    static let colorCodeTurkuazBlue = UIColor(red: 28/255, green: 192/255, blue: 230/255, alpha: 1.0)
    static let colorCodeRed = UIColor(red: 255/255, green: 57/255, blue: 57/255, alpha: 1.0)
    static let colorCodeLightBrown = UIColor(red: 231/255, green: 222/255, blue: 217/255, alpha: 1.0)
    static let colorCodeCreamy = UIColor(red: 241/255, green: 235/255, blue: 231/255, alpha: 1.0)
    static let twilightBlue = UIColor(red: 13/255, green: 75/255, blue: 160/255, alpha: 1.0)
    static let instalmentPriceGray = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1.0)
    static let instalmentTitleGray = UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 1.0)
    static let whiteThirteen = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
    static let colorCodeClear = UIColor.clear
    
    static var loadingImages = [UIImage]()
    
}






func LoaderImages() -> [UIImage] {
    
    var i = 204
    while i >= 2 {
        //print(i)
        i = i - 1
        UIDecorators.loadingImages.append(UIImage(named: "loaderAnim\(i).jpg")!)
    }
    
    
    /*for i in 204>..1
    {
    UIDecorators.loadingImages.append(UIImage(named: "loaderAnim\(i).jpg")!)
    }*/
    return UIDecorators.loadingImages
}

// Mapping from XML/HTML character entity reference to character
// From http://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references
private let characterEntities : [ Substring : Character ] = [
    // XML predefined entities:
    "&quot;"    : "\"",
    "&amp;"     : "&",
    "&apos;"    : "'",
    "&lt;"      : "<",
    "&gt;"      : ">",
    
    // HTML character entity references:
    "&nbsp;"    : "\u{00a0}",
    // ...
    "&diams;"   : "♦",
]

extension String {
    
    /// Returns a new string made by replacing in the `String`
    /// all HTML character entity references with the corresponding
    /// character.
    var stringByDecodingHTMLEntities : String {
        
        // ===== Utility functions =====
        
        // Convert the number in the string to the corresponding
        // Unicode character, e.g.
        //    decodeNumeric("64", 10)   --> "@"
        //    decodeNumeric("20ac", 16) --> "€"
        func decodeNumeric(_ string : Substring, base : Int) -> Character? {
            guard let code = UInt32(string, radix: base),
                let uniScalar = UnicodeScalar(code) else { return nil }
            return Character(uniScalar)
        }
        
        // Decode the HTML character entity to the corresponding
        // Unicode character, return `nil` for invalid input.
        //     decode("&#64;")    --> "@"
        //     decode("&#x20ac;") --> "€"
        //     decode("&lt;")     --> "<"
        //     decode("&foo;")    --> nil
        func decode(_ entity : Substring) -> Character? {
            
            if entity.hasPrefix("&#x") || entity.hasPrefix("&#X") {
                return decodeNumeric(entity.dropFirst(3).dropLast(), base: 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(entity.dropFirst(2).dropLast(), base: 10)
            } else {
                return characterEntities[entity]
            }
        }
        
        // ===== Method starts here =====
        
        var result = ""
        var position = startIndex
        
        // Find the next '&' and copy the characters preceding it to `result`:
        while let ampRange = self[position...].range(of: "&") {
            result.append(contentsOf: self[position ..< ampRange.lowerBound])
            position = ampRange.lowerBound
            
            // Find the next ';' and copy everything from '&' to ';' into `entity`
            guard let semiRange = self[position...].range(of: ";") else {
                // No matching ';'.
                break
            }
            let entity = self[position ..< semiRange.upperBound]
            position = semiRange.upperBound
            
            if let decoded = decode(entity) {
                // Replace by decoded character:
                result.append(decoded)
            } else {
                // Invalid entity, copy verbatim:
                result.append(contentsOf: entity)
            }
        }
        // Copy remaining characters to `result`:
        result.append(contentsOf: self[position...])
        return result
    }
}
