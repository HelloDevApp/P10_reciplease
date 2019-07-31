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
        (self.parent ?? self).present(alert, animated: true, completion: nil)
    }
    
    func changeSizeCell(tableView: UITableView) {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        if UIDevice.current.orientation.isPortrait {
            tableView.rowHeight = tableView.frame.height / 5
        } else {
            tableView.rowHeight = tableView.frame.height / 2.7
        }
    }
}
