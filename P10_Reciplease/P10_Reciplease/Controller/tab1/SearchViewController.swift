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
    
    // MARK: - Properties
    let impact = UIImpactFeedbackGenerator(style: .heavy)
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureToHideKeyboard()
        updateUserIngredients(action: .get, indexPath: nil)
    }
    
    // MARK: - #@IBActions
    @IBAction func actionAddButton(_ sender: UIButton) {
        addUserIngredientToArray()
    }
    
    @IBAction func actionClearButton(_ sender: UIButton) {
        updateUserIngredients(action: .removeAll, indexPath: nil)
        tableView.reloadData()
        impact.impactOccurred()
        
    }
    
    func addUserIngredientToArray() {
        if let ingredient = ingredientTextField.text, ingredient.count > 2 {
            let indexPath: IndexPath
            Data.userIngredients.append(ingredient)
            updateUserIngredients(action: .set, indexPath: nil)
            indexPath = IndexPath(row: Data.userIngredients.count - 1, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
            resetText(textField: ingredientTextField)
            impact.impactOccurred()
        }
    }
    
    // required IndexPath only for .remove
    func updateUserIngredients(action: Choice, indexPath: IndexPath?) {
        let userDefaultsManager = UserDefaultsManager()
        let key = userDefaultsManager.userIngredientsKey
        
        switch action {
        case .get:
            userDefaultsManager.get(to: &Data.userIngredients, key: key)
        case .set:
            userDefaultsManager.set(to: Data.userIngredients, key: key)
        case .remove:
            guard let indexPath = indexPath else { return }
            userDefaultsManager.remove(to: &Data.userIngredients, key: key, indexPath: indexPath)
        case .removeAll:
            userDefaultsManager.removeAll(to: &Data.userIngredients, key: key)
        }
    }
    
    func resetText(textField: UITextField) {
        textField.text = ""
    }
}

// MARK: - Navigation
extension SearchViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let segueID = "SearchToResult"
        guard segue.identifier == segueID else { return }
        if let resultVC = segue.destination as? ResultViewController {
            APIHelper.getRecipe() { (apiResult) in
                guard apiResult != nil else { return } // ?*?*?
                resultVC.tableView.reloadData() // ?*?*?
            }
        }
    }
}


// MARK: - TableView
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.userIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        fillCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func fillCell(cell: UITableViewCell, indexPath: IndexPath) {
        cell.backgroundColor = #colorLiteral(red: 0.1219023839, green: 0.129180491, blue: 0.1423901618, alpha: 1)
        if let labelCell = cell.textLabel {
            updateUserIngredients(action: .get, indexPath: nil)
            updateLabelCell(labelCell: labelCell, indexPath: indexPath)
        }
        tableView.rowHeight = tableView.frame.height / 6
    }
    
    func updateLabelCell(labelCell: UILabel, indexPath: IndexPath) {
        labelCell.textColor = .white
        labelCell.text = "∙  \(Data.userIngredients[indexPath.row])"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteRow(indexPath: indexPath)
            impact.impactOccurred()
        }
    }
    
    func deleteRow(indexPath: IndexPath) {
        updateUserIngredients(action: .remove, indexPath: indexPath)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
    
}
