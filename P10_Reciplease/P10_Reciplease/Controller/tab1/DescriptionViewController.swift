//
//  DescriptionViewController.swift
//  P10_Reciplease
//
//  Created by macbook pro on 23/05/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController, Favorites {
    
    
    // MARK: - @IBOutlets
    @IBOutlet weak var featuredButton: UIBarButtonItem!

    @IBOutlet weak var recipeImageView: UIImageView!
    
    // MARK: - @IBActions
    @IBAction func featuredButtonAction(_ sender: UIBarButtonItem) {
        
        // TO-DO: - add toggle Label
        changeTintColor(barButtonItem: featuredButton)
        
        let recipe = Recipe(name: "ok", numberOfIngredients: 2, directions: "olives, oignons, piment, salade, tomates..", numberOfLike: 300, time: 30)
        
        save(recipe: recipe)
        print("element enregistré")
        
        
    }
}


// MARK: - Navigation
extension DescriptionViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
