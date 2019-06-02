//
//  ExtensionUIView.swift
//  P10_Reciplease
//
//  Created by macbook pro on 23/05/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit

extension UIView {
    
    // allows you to add a gesture associated with closing the keyboard
    public func addGestureToHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
    
    // allows you to hide the keyboard
    @objc func hideKeyboard() {
        self.endEditing(true)
    }
}
