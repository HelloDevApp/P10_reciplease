//
//  NetworkController.swift
//  P10_Reciplease
//
//  Created by macbook pro on 12/07/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit

class NetworkController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methods Error Network
    func switchErrorNetworkToPresentAlert(errorNetwork: ErrorNetwork, hitsIsEmpty: Bool) {
        
        switch errorNetwork {
        case .noError:
            if hitsIsEmpty {
                parent?.presentAlert(titleAlert: .sorry, messageAlert: .noOtherRecipesFound, actionTitle: .ok, completion: nil)
            }
        case .noRecipeFound:
            parent?.presentAlert(titleAlert: .sorry, messageAlert: .noRecipeFound, actionTitle: .ok, completion: nil)
        case .requestHasFailed:
            parent?.presentAlert(titleAlert: .error, messageAlert: .requestHasFailed, actionTitle: .ok, completion: nil)
        case .requestLimitReached:
            parent?.presentAlert(titleAlert: .error, messageAlert: .requestLimitReached, actionTitle: .ok, completion: nil)
       case .wrongJSON:
            parent?.presentAlert(titleAlert: .error, messageAlert: .requestHasFailed, actionTitle: .ok, completion: nil)
        }
    }
    
    // MARK: - Update Request
    func updateFromAndToForNextCall(apiHelper: APIHelper?, hits: [Hit]) {
        if let apiHelper = apiHelper {
            apiHelper.from = hits.count + 1
            apiHelper.to = apiHelper.from + 10
            
        }
    }
    
    // MARK: - Activity Indicator
    func stopActivityIndicator(controller: NetworkController) {
        if let controller = controller as? SearchViewController {
            controller.searchForRecipesButton.isEnabled = true
            controller.activityIndicator.isHidden = true
            controller.activityIndicator.stopAnimating()
        } else if let controller = controller as? ResultViewController {
            controller.activityIndicator.isHidden = true
            controller.activityIndicator.stopAnimating()
        }
    }
    
    func startActivityIndicator(controller: NetworkController) {
        if let controller = controller as? ResultViewController {
            controller.activityIndicator.isHidden = false
            controller.activityIndicator.startAnimating()
        } else if let controller = controller as? SearchViewController {
            controller.searchForRecipesButton.isEnabled = false
            controller.activityIndicator.isHidden = false
            controller.activityIndicator.startAnimating()
        }
    }
}
