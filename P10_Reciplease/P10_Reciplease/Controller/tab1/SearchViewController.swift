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
class SearchViewController: NetworkController {
    
    // MARK: - @IBOutlets
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchForRecipesButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    let impact = UIImpactFeedbackGenerator(style: .heavy)
    
    var userIngredients = [String]()
    let apiHelper = APIHelper()
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
        firstCall()
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureToHideKeyboard()
        ud_updateUserIngredients(action: .get, indexPath: nil)
    }
    
    func addUserIngredientToArray() {
        guard let ingredient = ingredientTextField.text, ingredient.count > 2 else { return }
        let indexPath: IndexPath = IndexPath(row: userIngredients.count - 1, section: 0)
        userIngredients.append(ingredient)
        ud_updateUserIngredients(action: .set, indexPath: nil)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
        resetText(textField: ingredientTextField)
        impact.impactOccurred()
    }
    
    /// ud = UserDefaults
    /// required IndexPath only for .remove
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
    
    func firstCall() {
        
        guard !self.userIngredients.isEmpty else {
            self.parent?.presentAlert(titleAlert: .error, messageAlert: .userIngredientsIsEmpty, actionTitle: .ok, completion: nil)
            return
        }
        
        self.apiHelper.from = 0
        self.apiHelper.to = 19
        
        startActivityIndicator(controller: self)
        
        self.apiHelper.getRecipe(userIngredients: self.userIngredients) { [weak self] (apiResult, errorNetwork) in
            guard let self = self else { return }
            guard let apiResult = apiResult else {
                self.switchErrorNetworkToPresentAlert(errorNetwork: errorNetwork, hitsIsEmpty: true)
                self.stopActivityIndicator(controller: self)
                return
            }
            
            print(errorNetwork)
            
            if apiResult.hits.isEmpty {
                self.switchErrorNetworkToPresentAlert(errorNetwork: errorNetwork, hitsIsEmpty: true)
                self.stopActivityIndicator(controller: self)
                return
            } else {
                self.switchErrorNetworkToPresentAlert(errorNetwork: errorNetwork, hitsIsEmpty: false)
            }
            
            self.stopActivityIndicator(controller: self)
            self.hits = apiResult.hits
            self.performSegue(withIdentifier: "SearchToResult", sender: nil)
        }
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        loadView()
        changeSizeCell()
        tableView.reloadData()
    }
    
    func changeSizeCell() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        if UIDevice.current.orientation.isPortrait {
            tableView.rowHeight = tableView.frame.height / 5
        } else {
            tableView.rowHeight = tableView.frame.height / 3
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        changeSizeCell()
        tableView.allowsSelection = false
        return userIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        fillCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func fillCell(cell: UITableViewCell, indexPath: IndexPath) {
        cell.backgroundColor = #colorLiteral(red: 0.1219023839, green: 0.129180491, blue: 0.1423901618, alpha: 1)
        guard let labelCell = cell.textLabel else { return }
        ud_updateUserIngredients(action: .get, indexPath: nil)
        updateLabelCell(labelCell: labelCell, indexPath: indexPath)
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
