//
//  DescriptionViewController.swift
//  P10_Reciplease
//
//  Created by macbook pro on 23/05/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController, Favorites, DataService {
    
    let recipe = Recipe(name: "pates carbonara", numberOfIngredients: 4, directions: "lorem ipsum", numberOfLike: 300, time: 20, isFavorite: false)
    
    // MARK: - @IBOutlets
    @IBOutlet weak var recipeImageView: UIImageView!
}


// MARK: - Navigation
extension DescriptionViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
