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
    private var coreDataManager: CoreDataManager {
        guard let cdm = (UIApplication.shared.delegate as? AppDelegate)?.coreDataManager else { return CoreDataManager() }
        return cdm
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        fetchRecipes()
        changeSeparatorStyle(tableView)
        tableView.reloadData()
    }
    
    func fetchRecipes() {
        guard !coreDataManager.read().isEmpty else {
            parent?.presentAlert(titleAlert: .error, messageAlert: .favoriteRecipesIsEmpty, actionTitle: .ok) { (alert) in
                self.tabBarController?.selectedIndex = 0
            }
            return
        }
        coreDataManager.favoritesRecipes_ = coreDataManager.read()
        tableView.reloadData()
    }
    
}


// MARK: - Navigation
extension FavoritesResultViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "FavoritesToFavoritesDescription" else { return }
        guard let favoritesDescriptionVC = segue.destination as? FavoritesDescriptionViewController else { return }
        let recipe_ = coreDataManager.favoritesRecipes_[rowSelect]
        guard let label = recipe_.label, let url = recipe_.url, let uri = recipe_.uri, let ingredients = recipe_.ingredientLines as? [String] else { return }
        let recipe = Recipe(label: label, image: recipe_.image, url: url, uri: uri, ingredientLines: ingredients, totalTime: recipe_.totalTime, imageData: recipe_.imageData)
        favoritesDescriptionVC.recipe = recipe
        favoritesDescriptionVC.coreDataManager = coreDataManager
    }
}

// MARK: - TableView
extension FavoritesResultViewController: UITableViewDataSource, UITableViewDelegate {
    
    @objc func refreshTableView() {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataManager.favoritesRecipes_.count
    }
    
    fileprivate func changeSeparatorStyle(_ tableView: UITableView) {
        switch coreDataManager.favoritesRecipes_.count {
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as? ResultTableViewCell else { return UITableViewCell() }
        fillCell(cell, with: coreDataManager.favoritesRecipes_, indexPath: indexPath)
        
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
        guard let imageData = recipe.imageData else {
            print("return favorite image data == nil")
            cell.noImageLabel.isHidden = false
            cell.noImageLabel.text = ErrorMessages.noImageAvailable.rawValue
            cell.recipeImageView.image = Constants.noImage
            tableView.reloadRows(at: [indexPath], with: .automatic)
            return
        }
        cell.recipeImageView.image = UIImage(data: imageData)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {

            coreDataManager.delete(recipe_: coreDataManager.favoritesRecipes_[indexPath.row])
            
            // refresh count of favoritesRecipes to display correct tableView
            coreDataManager.favoritesRecipes_ = coreDataManager.read()
            changeSeparatorStyle(tableView)
            tableView.reloadData()
            
            if coreDataManager.favoritesRecipes_.count == 0 {
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
            
            let timeConvert = String(format: "%.2f", timerecipe / 60).replacingOccurrences(of: ".", with: "h")
            
            cell.timeLabel.text = timeConvert
        }
    }
}
