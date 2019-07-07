//
//  SearchViewController.swift
//  P10_Reciplease
//
//  Created by macbook pro on 23/05/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit

enum Choice {
    case get
    case set
    case remove
    case removeAll
}
class SearchViewController: UIViewController {
    
    // MARK: - @IBOutlets
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchForRecipesButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    let impact = UIImpactFeedbackGenerator(style: .heavy)
    
    // For Search
    var userIngredients = [String]()
    var apiResult: APIResult?
    let apiHelper = APIHelper()
    
    // For ResultVC
    var hits = [Hit]()
    
    // MARK: - #@IBActions
    @IBAction func actionAddButton(_ sender: UIButton) {
        addUserIngredientToArray()
    }
    
    @IBAction func actionClearButton(_ sender: UIButton) {
        ud_updateUserIngredients(action: .removeAll, indexPath: nil)
        tableView.reloadData()
        impact.impactOccurred()
        
    }
    
    @IBAction func actionSearchButton(_ sender: UIButton) {
        startActivityIndicator()
        launchCall()
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureToHideKeyboard()
        ud_updateUserIngredients(action: .get, indexPath: nil)
    }
    func addUserIngredientToArray() {
        if let ingredient = ingredientTextField.text, ingredient.count > 2 {
            let indexPath: IndexPath = IndexPath(row: userIngredients.count - 1, section: 0)
            userIngredients.append(ingredient)
            ud_updateUserIngredients(action: .set, indexPath: nil)
            tableView.insertRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
            resetText(textField: ingredientTextField)
            impact.impactOccurred()
        }
    }
    
    // required IndexPath only for .remove
    // ud = UserDefaults
    func ud_updateUserIngredients(action: Choice, indexPath: IndexPath?) {
        let userDefaultsManager = UserDefaultsManager()
        let key = userDefaultsManager.userIngredientsKey
        
        switch action {
        case .get:
            userDefaultsManager.get(to: &userIngredients, key: key)
        case .set:
            userDefaultsManager.set(to: userIngredients, key: key)
        case .remove:
            guard let indexPath = indexPath else { return }
            userDefaultsManager.remove(to: &userIngredients, key: key, indexPath: indexPath)
        case .removeAll:
            userDefaultsManager.removeAll(to: &userIngredients, key: key)
        }
    }
    
    func resetText(textField: UITextField) {
        textField.text = ""
    }
}

//MARK: - API call
extension SearchViewController {
    
    func launchCall() {
        guard !userIngredients.isEmpty else {
            parent?.presentAlert(titleAlert: .error, messageAlert: .userIngredientsIsEmpty, actionTitle: .ok, statusCode: nil, completion: nil)
            return
        }
        startActivityIndicator()
        apiHelper.from = 1
        apiHelper.to = 20
        
        apiHelper.getRecipe(userIngredients: userIngredients) { [weak self] (apiResult, statusCode) in
            guard let apiResult = apiResult, !apiResult.hits.isEmpty else {
                self?.parent?.presentAlert(titleAlert: .sorry, messageAlert: .requestHasFailed, actionTitle: .ok, statusCode: nil, completion: nil)
                self?.stopActivityIndicator()
                
                guard let statusCode = statusCode else {
                     self?.parent?.presentAlert(titleAlert: .sorry, messageAlert: .requestHasFailed, actionTitle: .ok, statusCode: nil, completion: nil)
                    self?.stopActivityIndicator()
                    return
                }
                
                switch statusCode {
                case 401:
                    self?.parent?.presentAlert(titleAlert: .sorry, messageAlert: .requestLimitReached, actionTitle: .ok, statusCode: statusCode, completion: nil)
                    print("error: \(statusCode)")
                default:
                    self?.parent?.presentAlert(titleAlert: .error, messageAlert: .requestHasFailed, actionTitle: .ok, statusCode: statusCode, completion: nil)
                    print("error: \(statusCode)")
                }
                self?.stopActivityIndicator()
                return
                    
            }
            self?.hits = apiResult.hits
            self?.stopActivityIndicator()
            self?.performSegue(withIdentifier: "SearchToResult", sender: nil)
        }
    }
    
    func startActivityIndicator() {
        self.searchForRecipesButton.isEnabled = false
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        self.searchForRecipesButton.isEnabled = true
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
    }
}

// MARK: - Navigation
extension SearchViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "SearchToResult" else { return }
        if let resultVC = segue.destination as? ResultViewController {
            resultVC.userIngredients = self.userIngredients
            resultVC.apiHelper = apiHelper
            resultVC.hits = hits
        }
    }
}


// MARK: - TableView
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        fillCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func fillCell(cell: UITableViewCell, indexPath: IndexPath) {
        cell.backgroundColor = #colorLiteral(red: 0.1219023839, green: 0.129180491, blue: 0.1423901618, alpha: 1)
        if let labelCell = cell.textLabel {
            ud_updateUserIngredients(action: .get, indexPath: nil)
            updateLabelCell(labelCell: labelCell, indexPath: indexPath)
        }
        tableView.rowHeight = tableView.frame.height / 6
    }
    
    func updateLabelCell(labelCell: UILabel, indexPath: IndexPath) {
        labelCell.textColor = .white
        labelCell.text = "∙  \(userIngredients[indexPath.row])"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteRow(indexPath: indexPath)
            impact.impactOccurred()
        }
    }
    
    func deleteRow(indexPath: IndexPath) {
        ud_updateUserIngredients(action: .remove, indexPath: indexPath)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
}
