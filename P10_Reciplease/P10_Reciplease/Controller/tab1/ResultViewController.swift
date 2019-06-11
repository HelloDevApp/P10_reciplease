//
//  ResultViewController.swift
//  P10_Reciplease
//
//  Created by macbook pro on 23/05/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
}

// MARK: - Navigation
extension ResultViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

// MARK: - TableView
extension ResultViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            tableView.backgroundColor = #colorLiteral(red: 0.1219023839, green: 0.129180491, blue: 0.1423901618, alpha: 1)
            tableView.separatorStyle = .none
        return Data.hits.count
    }
    
    func fillCell(_ cell: ResultTableViewCell, with hits: [Hit], indexPath: IndexPath) {
        let hit = hits[indexPath.row]
        let ingredients = hit.recipe.ingredientLines.joined(separator: ", ")
        let nameRecipe = hit.recipe.label
        let timeRecipe = hit.recipe.totalTime
        
        updateNameRecipeLabel(cell: cell, nameRecipe: nameRecipe)
        updateIngredientsLabel(cell: cell, ingredients: ingredients)
        updateTimeLabel(cell: cell, time: timeRecipe)
        getImage(cell: cell, hit: hit)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let favoritesAction = UITableViewRowAction(style: .default, title: "➕Favorites", handler: { (action, indexPath) in
                // add actions (save to favorites list) and core data
            let recipe = Data.hits[indexPath.row].recipe
            let image = Data.imageRecipe[indexPath.row]
            Data.favorite.append(recipe)
            Data.imageFavorite.append(image)
        })
        
        favoritesAction.backgroundColor = UIColor.darkText
        return [favoritesAction]
    }
 
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        tableView.rowHeight = tableView.frame.height / 3
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as? ResultTableViewCell {
            fillCell(cell, with: Data.hits, indexPath: indexPath)
            return cell
        }
        let cellStandard = UITableViewCell()
        return cellStandard
    }
    
    func updateNameRecipeLabel(cell: ResultTableViewCell, nameRecipe: String) {
        cell.nameRecipeLabel.text = nameRecipe
    }
    
    func updateIngredientsLabel(cell: ResultTableViewCell, ingredients: String) {
        cell.ingredientsLabel.text = ingredients
    }
    
    func getImage(cell: ResultTableViewCell, hit: Hit) {
        guard let urlImage = hit.recipe.image else { return }
        APIHelper.getImage(url: urlImage) { (image) in
            cell.noImageLabel.isHidden = true
            cell.recipeImageView.image = image
            cell.recipeImageView.contentMode = .scaleAspectFill
            cell.recipeImageView.alpha = 0.7
        }
    }
    
    func updateTimeLabel(cell: ResultTableViewCell, time: Int?) {
        if let timerecipe = time {
            let time = String(timerecipe)
            cell.timeLabel.text = time
        }
    }
    

}
