//
//  FeaturedRecipeViewController.swift
//  P10_Reciplease
//
//  Created by macbook pro on 30/05/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher

class FavoritesResultViewController: UIViewController {
    
    var rowSelect = 0
    let coreDataManager = CoreDataManager()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        fetchRecipes()
        changeSeparatorStyle(tableView)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    func fetchRecipes() {
        guard !coreDataManager.fetchRecipes().isEmpty else {
            parent?.presentAlert(titleAlert: .error, messageAlert: .favoriteRecipesIsEmpty, actionTitle: .ok) { (alert) in
                self.tabBarController?.selectedIndex = 0
            }
            return
        }
        coreDataManager.favoritesRecipes = coreDataManager.fetchRecipes()
        tableView.reloadData()
    }
    
}


// MARK: - Navigation
extension FavoritesResultViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "FavoritesToFavoritesDescription" else { return }
        guard let favoritesDescriptionVC = segue.destination as? FavoritesDescriptionViewController else { return }
        favoritesDescriptionVC.recipe = coreDataManager.favoritesRecipes[rowSelect]
    }
}

// MARK: - TableView
extension FavoritesResultViewController: UITableViewDataSource, UITableViewDelegate {
    
    @objc func refreshTableView() {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataManager.favoritesRecipes.count
    }
    
    fileprivate func changeSeparatorStyle(_ tableView: UITableView) {
        switch coreDataManager.favoritesRecipes.count {
        case 0...2:
            tableView.separatorStyle = .none
        case 3...Int.max:
            tableView.separatorStyle = .singleLine
            tableView.separatorColor = .black
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.rowHeight = tableView.frame.height / 3
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as? ResultTableViewCell else { return UITableViewCell() }
        fillCell(cell, with: coreDataManager.favoritesRecipes, indexPath: indexPath)
        
        return cell
    }
    
    func fillCell(_ cell: ResultTableViewCell, with recipes: [Recipe_?], indexPath: IndexPath) {
        
        guard let recipe = recipes[indexPath.row] else { return }
        guard let nameRecipe = recipe.label else { return }
        guard let ingredientLines = recipe.ingredientLines as? [String] else { return }
        
        let ingredients = ingredientLines.joined(separator: ", \n")
        let timeRecipe = recipe.totalTime
        
        updateNameRecipeLabel(cell: cell, nameRecipe: nameRecipe, indexPath: indexPath)
        updateIngredientsLabel(cell: cell, ingredients: ingredients)
        updateTimeLabel(cell: cell, time: timeRecipe)
        
        cell.recipeImageView.contentMode = .scaleAspectFill
        if let imageURL = recipe.image {
            cell.noImageLabel.isHidden = true
            cell.recipeImageView.kf.setImage(with: .network(imageURL), placeholder: nil, options: [.cacheOriginalImage, .transition(.fade(0.5)), .forceRefresh], progressBlock: nil, completionHandler: nil)
        } else {
            cell.noImageLabel.isHidden = false
            cell.noImageLabel.text = ErrorMessages.noImageAvailable.rawValue
            cell.recipeImageView.image = #imageLiteral(resourceName: "defaultImage")
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            coreDataManager.viewContext.delete(coreDataManager.favoritesRecipes[indexPath.row])
            coreDataManager.saveContext()
            
            // refresh count of favoritesRecipes to display correct tableView
            coreDataManager.favoritesRecipes = coreDataManager.fetchRecipes()
            changeSeparatorStyle(tableView)
            tableView.reloadData()
            
            if coreDataManager.favoritesRecipes.count == 0 {
                parent?.presentAlert(titleAlert: .sorry, messageAlert: .favoriteRecipesIsEmpty, actionTitle: .ok) { (alert) in
                    self.tabBarController?.selectedIndex = 0
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowSelect = indexPath.row
        performSegue(withIdentifier: "FavoritesToFavoritesDescription", sender: nil)
    }
    
    func updateNameRecipeLabel(cell: ResultTableViewCell, nameRecipe: String, indexPath: IndexPath) {
        cell.nameRecipeLabel.text = "\(indexPath.row + 1) " + nameRecipe
    }
    
    func updateIngredientsLabel(cell: ResultTableViewCell, ingredients: String) {
        cell.ingredientsLabel.text = ingredients
    }
    
    func updateTimeLabel(cell: ResultTableViewCell, time: Double?) {
        if let timerecipe = time {
            let time = String(timerecipe)
            cell.timeLabel.text = time
        }
    }
}
