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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        if RecipeHelper.favoritesRecipes.count == 0 {
            // TO-DO: - Hidden noimageLabel
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if RecipeHelper.favoritesRecipes.count <= 0 {
            tableView.separatorStyle = .none
        }
        return RecipeHelper.favoritesRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.rowHeight = tableView.frame.height / 4
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as? ResultTableViewCell {
            
            cell.setup(recipeImageView: cell.recipeImageView, recipeImage: cell.defaultImage, defaultImage: cell.defaultImage, noImageLabel: cell.noImageLabel, nameRecipeLabel: cell.nameRecipeLabel, nameRecipe: "Salade Romaine", ingredientsLabel: cell.ingredientsLabel, detailIngredients: "poulet, salade, maïs, tomates, olives", numberOfLikeLabel: cell.numberOfLike, numberOfLike: 300, timeLabel: cell.timeLabel, time: 12)
            
            return cell
        }
        return UITableViewCell()
    }
}
