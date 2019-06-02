//
//  FeaturedRecipeViewController.swift
//  P10_Reciplease
//
//  Created by macbook pro on 30/05/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit

class FavoritesResultViewController: UIViewController {

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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if RecipeHelper.favoritesRecipes.count <= 0 {
            tableView.separatorStyle = .none
        }
        return RecipeHelper.favoritesRecipes.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as? ResultTableViewCell {
            
            cell.configure(image: #imageLiteral(resourceName: "defaultImage"), nameRecipe: "(nameRecipe)", detailIngredients: "(cheese, beef, potatoes)" , numberOflike: 100, time: 02)
            
            return cell
        }
        return UITableViewCell()
    }
    
}
