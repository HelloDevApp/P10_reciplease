//
//  NetworkProtocol.swift
//  P10_Reciplease
//
//  Created by macbook pro on 08/07/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit
import Foundation

protocol NetworkProtocol {
    
}

extension NetworkProtocol {
    
    func switchStatusCodeToPresentAlert(statusCode: Int?, controller: UIViewController, hitsIsEmpty: Bool) {
        guard let statusCode = statusCode else {
            controller.parent?.presentAlert(titleAlert: .sorry, messageAlert: .requestHasFailed, actionTitle: .ok, statusCode: nil, completion: nil)
            return
        }
        print(statusCode)
        switch statusCode {
        case 200:
            if hitsIsEmpty {
                controller.presentAlert(titleAlert: .sorry, messageAlert: .noRecipeFound, actionTitle: .ok, statusCode: nil, completion: nil)
            }
        case 400:
            controller.parent?.presentAlert(titleAlert: .error, messageAlert: .requestHasFailed, actionTitle: .ok, statusCode: statusCode, completion: nil)
        case 401:
            controller.parent?.presentAlert(titleAlert: .error, messageAlert: .requestLimitReached, actionTitle: .ok, statusCode: statusCode, completion: nil)
        case 402...499:
            controller.parent?.presentAlert(titleAlert: .error, messageAlert: .requestHasFailed, actionTitle: .ok, statusCode: statusCode, completion: nil)
        case 500...599:
            controller.parent?.presentAlert(titleAlert: .error, messageAlert: .requestHasFailed, actionTitle: .ok, statusCode: statusCode, completion: nil)
        default:
            controller.parent?.presentAlert(titleAlert: .error, messageAlert: .requestHasFailed, actionTitle: .ok, statusCode: statusCode, completion: nil)
        }
    }
}
