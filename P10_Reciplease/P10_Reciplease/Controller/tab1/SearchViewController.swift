//
//  SearchViewController.swift
//  P10_Reciplease
//
//  Created by macbook pro on 23/05/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit

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
        
    }
    
    // MARK: - #@IBActions
    @IBAction func actionAddButton(_ sender: UIButton) {
        
        if let ingredient = ingredientTextField.text, ingredient.count > 2 {
            
            let indexPath = IndexPath(row: Recipe.ingredients.count - 1, section: 0)
            Recipe.ingredients.append("- " + ingredient)
            ingredientTextField.text = ""
            tableView.insertRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
            impact.impactOccurred()
        }
        
    }
    
    @IBAction func actionClearButton(_ sender: UIButton) {
        Recipe.ingredients = []
        tableView.reloadData()
        impact.impactOccurred()
        
    }
}

// MARK: - Navigation
extension SearchViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}


// MARK: - TableView
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Recipe.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = createCell(indexPath: indexPath)
        return cell
    }
    
    func createCell(indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as? SearchTableViewCell {
            cell.setTitle(label: cell.ingredientsLabel, text: Recipe.ingredients[indexPath.row])
            tableView.rowHeight = tableView.frame.height / 6
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            deleteRow(indexPath: indexPath)
            impact.impactOccurred()
        }
    }
    
    func deleteRow(indexPath: IndexPath) {
        Recipe.ingredients.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
    
}
