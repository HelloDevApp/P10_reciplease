//
//  FeaturedRecipeViewController.swift
//  P10_Reciplease
//
//  Created by macbook pro on 30/05/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit

class FavoritesResultViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noFavoritesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        if Recipe.favoritesRecipes.count == 0 {
            // TO-DO: - Hidden noimageLabel
//        }
    }
}


// MARK: - Navigation
extension FavoritesResultViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

// MARK: - TableView
extension FavoritesResultViewController: UITableViewDataSource, UITableViewDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Data.favorite.count == 0 {
            noFavoritesLabel.isHidden = true
        }
        return Data.favorite.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.rowHeight = tableView.frame.height / 3
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as? ResultTableViewCell {
            
            let recipes = Data.favorite
            fillCell(cell, with: recipes, indexPath: indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    func fillCell(_ cell: ResultTableViewCell, with recipes: [Recipe], indexPath: IndexPath) {
        let recipe = recipes[indexPath.row]
        let ingredients = recipe.ingredientLines.joined(separator: ", ")
        let nameRecipe = recipe.label
        let timeRecipe = recipe.totalTime
        let image = Data.imageFavorite[indexPath.row]
        
        updateNameRecipeLabel(cell: cell, nameRecipe: nameRecipe)
        updateIngredientsLabel(cell: cell, ingredients: ingredients)
        updateTimeLabel(cell: cell, time: timeRecipe)
        updateImage(cell: cell, image: image, indexPath: indexPath)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            Data.favorite.remove(at: indexPath.row)
            Data.imageFavorite.remove(at: indexPath.row)
            tableView.reloadData()
            print(Data.favorite.count)
        }
    }
    
    func updateNameRecipeLabel(cell: ResultTableViewCell, nameRecipe: String) {
        cell.nameRecipeLabel.text = nameRecipe
    }
    
    func updateIngredientsLabel(cell: ResultTableViewCell, ingredients: String) {
        cell.ingredientsLabel.text = ingredients
    }
    
    func updateImage(cell: ResultTableViewCell, image: UIImage, indexPath: IndexPath) {
        cell.noImageLabel.isHidden = true
        cell.recipeImageView.image = Data.imageFavorite[indexPath.row]
        cell.recipeImageView.contentMode = .scaleAspectFill
        cell.recipeImageView.alpha = 0.7
    }
    
    func updateTimeLabel(cell: ResultTableViewCell, time: Int?) {
        if let timerecipe = time {
            let time = String(timerecipe)
            cell.timeLabel.text = time
        }
    }
}
