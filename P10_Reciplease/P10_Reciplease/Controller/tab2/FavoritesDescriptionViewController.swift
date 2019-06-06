//
//  FeaturedDescriptionViewController.swift
//  P10_Reciplease
//
//  Created by macbook pro on 30/05/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit

class FavoritesDescriptionViewController: UIViewController, DataService, Favorites {
    
    let recipe = Recipe(name: "nameDefault", numberOfIngredients: 0, directions: "...", numberOfLike: 0, time: 0, isFavorite: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

// MARK: - Navigation
extension FavoritesDescriptionViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
