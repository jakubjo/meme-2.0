//
//  TextFieldDelegate.swift
//  MemeMe
//
//  Created by Jakub on 03.08.15.
//  Copyright (c) 2015 Jakub Jozefek. All rights reserved.
//

import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    var textField: UITextField
    var type: String
    var defaultText: String
    var isActive: Bool
    
    init(textFieldType: String, textField: UITextField) {
        isActive = false;
        
        self.textField = textField;
        
        type = (textFieldType == "top") ? "top" : "bottom"
        
        defaultText = (self.type == "top") ? "TOP" : "BOTTOM"
        
        
        let textAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -1.0
        ]
        
        self.textField.defaultTextAttributes = textAttributes
        
        self.textField.textAlignment = NSTextAlignment.Center
        
        self.textField.text = defaultText
    }
    
    func resetText() {
        textField.text = defaultText
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        isActive = true;
        
        if (textField.text == defaultText) {
            textField.text = "";
        }
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        isActive = false;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}