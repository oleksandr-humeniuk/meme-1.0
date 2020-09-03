//
//  MemeTextFieldDelegate.swift
//  Meme
//
//  Created by Oleksandr Humeniuk on 9/3/20.
//

import UIKit

class MemeTextFieldDelegate: NSObject,UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let text = textField.text
        if text == ViewController.Strings.TOP_INITIAL_TEXT || text == ViewController.Strings.BOTTOM_INITIAL_TEXT{
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
