//
//  Ingredients.swift
//  P10_Reciplease
//
//  Created by macbook pro on 23/05/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

class RecipeHelper {
    
    static var favoritesRecipes = [Recipe]()
    
    func createRecipe(name: String, numberOfIngredients: Int, directions: String, numberOfLike: Int, time: Int) -> Recipe {
        
        let recipe = Recipe(name: name, numberOfIngredients: numberOfIngredients, directions: directions, numberOfLike: numberOfLike, time: time)
        return recipe
    }
    
    func addRecipeToFavorites(recipe: Recipe) {
        RecipeHelper.favoritesRecipes.append(recipe)
    }
}
