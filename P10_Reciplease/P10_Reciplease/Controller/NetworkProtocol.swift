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
    
    /// indexPath only for ResultViewController
    func launchCall(controller: UIViewController) {
        
        if let controller = controller as? SearchViewController {
            firstCall(controller: controller)
        } else if let controller = controller as? ResultViewController {
            loadMoreRecipes(controller: controller)
        }
    }
    
    func firstCall(controller: SearchViewController) {

        guard !controller.userIngredients.isEmpty else {
            controller.parent?.presentAlert(titleAlert: .error, messageAlert: .userIngredientsIsEmpty, actionTitle: .ok, statusCode: nil, completion: nil)
            return
        }

        controller.apiHelper.from = 0
        controller.apiHelper.to = 19

        startActivityIndicator(controller: controller)

        controller.apiHelper.getRecipe(userIngredients: controller.userIngredients) { [weak controller] (apiResult, statusCode) in
            guard let controller = controller else { return }
            guard let apiResult = self.checkIfApiResultIsNotNil(apiResult: apiResult, controller: controller, statusCode: statusCode) else { return }
            
            self.stopActivityIndicator(controller: controller)
            controller.hits = apiResult.1
            controller.performSegue(withIdentifier: "SearchToResult", sender: nil)
        }
    }
    
    func loadMoreRecipes(controller: ResultViewController) {
        updateFromAndToForNextCall(apiHelper: controller.apiHelper, hits: controller.hits)
        guard let apiHelper = controller.apiHelper else { return }
        
        //sert juste a animer l'activityIndicator rien d'autre
        controller.startActivityIndicator(controller: controller)

        //lance l'appel
        apiHelper.getRecipe(userIngredients: controller.userIngredients, callback: { [weak controller] (apiResult, statusCode)  in

            guard let controller = controller else { return }
            // verifie que apiResult n'est pas nulet que le tableau contenant les recette n'est pas vide
            guard let apiResult = self.checkIfApiResultIsNotNil(apiResult: apiResult, controller: controller, statusCode: statusCode) else { return
            }
            
            // et la j'affecte les données recus 
            controller.hits.append(contentsOf: apiResult.hits)
            controller.tableView.reloadData()
            controller.stopActivityIndicator(controller: controller)
        })
    }
    
    func checkIfApiResultIsNotNil(apiResult: APIResult?, controller: UIViewController, statusCode: Int?) -> (apiResult: APIResult?, hits:  [Hit])? {
        
        if let controller = controller as? SearchViewController {
            
            guard let apiResult = apiResult else {
                switchStatusCodeToPresentAlert(statusCode: statusCode, controller: controller, hitsIsEmpty: true)
                stopActivityIndicator(controller: controller)
                return nil
            }
            
            guard !apiResult.hits.isEmpty else {
                switchStatusCodeToPresentAlert(statusCode: statusCode, controller: controller, hitsIsEmpty: true)
                stopActivityIndicator(controller: controller)
                return (apiResult, [])
            }
            return (apiResult, apiResult.hits)
            
        } else if let controller = controller as? ResultViewController {
            guard let apiResult = apiResult else {
                switchStatusCodeToPresentAlert(statusCode: statusCode, controller: controller, hitsIsEmpty: true)
                stopActivityIndicator(controller: controller)
                return nil
            }
            
            guard !apiResult.hits.isEmpty else {
                self.switchStatusCodeToPresentAlert(statusCode: statusCode, controller: controller, hitsIsEmpty: true)
                controller.stopActivityIndicator(controller: controller)
                return (apiResult, [])
            }
            return (apiResult, apiResult.hits)
        }
        return nil
    }
    
    func updateFromAndToForNextCall(apiHelper: APIHelper?, hits: [Hit]) {
        if let apiHelper = apiHelper {
            apiHelper.from = hits.count + 1
            apiHelper.to = apiHelper.from + 10
            
        }
    }
    
    func stopActivityIndicator(controller: UIViewController) {
        if let controller = controller as? SearchViewController {
            controller.searchForRecipesButton.isEnabled = true
            controller.activityIndicator.isHidden = true
            controller.activityIndicator.stopAnimating()
        } else if let controller = controller as? ResultViewController {
            controller.activityIndicator.isHidden = true
            controller.activityIndicator.stopAnimating()
        }
    }
    
    func startActivityIndicator(controller: UIViewController) {
        if let controller = controller as? ResultViewController {
            controller.activityIndicator.isHidden = false
            controller.activityIndicator.startAnimating()
        } else if let controller = controller as? SearchViewController {
            controller.searchForRecipesButton.isEnabled = false
            controller.activityIndicator.isHidden = false
            controller.activityIndicator.startAnimating()
        }
    }
    
    func switchStatusCodeToPresentAlert(statusCode: Int?, controller: UIViewController, hitsIsEmpty: Bool) {
        guard let statusCode = statusCode else {
            controller.parent?.presentAlert(titleAlert: .sorry, messageAlert: .requestHasFailed, actionTitle: .ok, statusCode: nil, completion: nil)
            return
        }
        print(statusCode)
        switch statusCode {
        case 200:
            if hitsIsEmpty {
                controller.parent?.presentAlert(titleAlert: .sorry, messageAlert: .noRecipeFound, actionTitle: .ok, statusCode: nil, completion: nil)
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
