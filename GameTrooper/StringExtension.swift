//
//  StringExtension.swift
//  GameTrooper
//
//  Created by Ray Krishardi Layadi on 30/5/17.
//  Copyright © 2017 Ray Krishardi Layadi. All rights reserved.
//

import Foundation
import UIKit

//-------------------------------------------------------------------------------------------------------------------------------
//                                                            Source:
//                     1. https://stackoverflow.com/questions/3586871/bold-non-bold-text-in-a-single-uilabel
//                     2. https://stackoverflow.com/questions/34915121/center-and-bold-part-of-a-text-in-swift
//                                                              By:
//                                                         1. "nacho4d"
//                                                     2. "Raphael Oliveira"
//-------------------------------------------------------------------------------------------------------------------------------

extension String {
    
    // Function that converts and returns normal string to attributed string with appropriate formatting/styling
    // Default styling is NOT bold with left alignment
    func getAttributedString(bold: Bool = false, alignment: String = "left") -> NSAttributedString {
        // Use the standard system font size
        let fontSize = UIFont.systemFontSize
        
        // Variable that represents the font attribute for the attributed string (i.e. normal or bold system font)
        let fontAttribute: UIFont!
        
        // Check whether the attributed string should be in bold or not
        // If bold is selected then apply the bold system font with the appropriate font size
        // If bold is NOT selected then apply the normal system font with the appropriate font size
        if bold {
            fontAttribute = UIFont.boldSystemFont(ofSize: fontSize)
        }
        else {
            fontAttribute = UIFont.systemFont(ofSize: fontSize)
        }
        
        // Variable that represents the alignment style for the attributed string (i.e. center/justified/left alignment)
        let style = NSMutableParagraphStyle()
        
        // Check the selected alignment for the attributed string
        // Apply the appropriate alignment (default -> left alignment)
        if alignment == "center" {
            style.alignment = .center
        }
        else if alignment == "justified" {
            style.alignment = .justified
        }
        else {
            style.alignment = .left
        }
        
        // Constant that represents the collection of attributes to be applied to the attributed string
        // In this case, whether the text should be bold or not and whether the text alignment should be center/justified/left
        let attributes = [
            NSFontAttributeName: fontAttribute,
            NSParagraphStyleAttributeName: style
            ] as [String : Any]
        
        // Create and return the attributed string with the appropriate content and attributes
        let attributedString = NSMutableAttributedString(string: self, attributes: attributes)
        return attributedString
    }
    
}

//-------------------------------------------------------------------------------------------------------------------------------
