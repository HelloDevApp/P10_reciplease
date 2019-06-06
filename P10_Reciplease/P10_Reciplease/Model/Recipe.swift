//
//  Recipe.swift
//  P10_Reciplease
//
//  Created by macbook pro on 02/06/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit

class Recipe {
    
    static var favoritesRecipes = [Recipe]()
    
    var image: UIImage?
    var name: String
    var numberOfIngredients: Int
    static var ingredients: [String] = [String]()
    var directions: String
    var numberOfLike: Int
    var time: Int
    var isFavorite: Bool?
    
    init(name: String, numberOfIngredients: Int, directions: String, numberOfLike: Int, time: Int, isFavorite: Bool) {
        self.name = name
        self.numberOfIngredients = numberOfIngredients
        self.directions = directions
        self.numberOfLike = numberOfLike
        self.time = time
        self.isFavorite = isFavorite
    }
    
    func createRecipe(name: String, numberOfIngredients: Int, directions: String, numberOfLike: Int, time: Int) -> Recipe {
        
        let recipe = Recipe(name: name, numberOfIngredients: numberOfIngredients, directions: directions, numberOfLike: numberOfLike, time: time, isFavorite: false)
        
        return recipe
    }
    
}
