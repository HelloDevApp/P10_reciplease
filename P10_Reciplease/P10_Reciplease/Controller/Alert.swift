//
//  Alert.swift
//  P10_Reciplease
//
//  Created by macbook pro on 20/06/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlert(titleAlert: ErrorMessages, messageAlert: ErrorMessages, actionTitle: ErrorMessages, completion: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: titleAlert.rawValue, message: messageAlert.rawValue, preferredStyle: .alert)
        
        let action = UIAlertAction(title: actionTitle.rawValue, style: .default, handler: completion)
        alert.addAction(action)
        self.parent?.present(alert, animated: true, completion: nil)
    }
}
