//
//  ResultViewController.swift
//  P10_Reciplease
//
//  Created by macbook pro on 23/05/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Navigation
extension ResultViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

// MARK: - TableView
// TO-DO: - Change number of row in section per number Of recipe receive by API

extension ResultViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 10
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if RecipeHelper.favoritesRecipes.count <= 0 {
//            tableView.separatorStyle = .none
//        }
//        return RecipeHelper.favoritesRecipes.count - 1
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.rowHeight = tableView.frame.height / 4
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as? ResultTableViewCell {
            
            cell.setup(recipeImageView: cell.recipeImageView, recipeImage: cell.defaultImage, defaultImage: cell.defaultImage, noImageLabel: cell.noImageLabel, nameRecipeLabel: cell.nameRecipeLabel, nameRecipe: "Salade Romaine", ingredientsLabel: cell.ingredientsLabel, detailIngredients: "poulet, salade, maïs, tomates, olives", numberOfLikeLabel: cell.numberOfLike, numberOfLike: 300, timeLabel: cell.timeLabel, time: 12)
            
            return cell
        }
        return UITableViewCell()
    }
    
}
