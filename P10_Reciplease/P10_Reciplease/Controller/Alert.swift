//
//  Alert.swift
//  P10_Reciplease
//
//  Created by macbook pro on 20/06/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlert(titleAlert: ErrorMessages, messageAlert: ErrorMessages, actionTitle: ErrorMessages, statusCode: Int?) {
        var alert: UIAlertController
        
        if let statusCode = statusCode {
            // we create a alert with an StatusCode messages
            let displaysStatusCode = "error: \(statusCode)\n"
            alert = UIAlertController(title: titleAlert.rawValue, message: displaysStatusCode + messageAlert.rawValue, preferredStyle: .alert)
        } else {
            // we create a alert with an StatusCode messages
            alert = UIAlertController(title: titleAlert.rawValue, message: messageAlert.rawValue, preferredStyle: .alert)
        }
        let action = UIAlertAction(title: actionTitle.rawValue, style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
