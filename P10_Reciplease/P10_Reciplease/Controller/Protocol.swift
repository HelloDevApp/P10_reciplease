//
//  FavoritesProtocol.swift
//  P10_Reciplease
//
//  Created by macbook pro on 02/06/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit

//MARK: -ResultCell Protocol
protocol ResultCell {}


extension ResultCell {
    
    func setup(recipeImageView: UIImageView, recipeImage: UIImage?, defaultImage: UIImage, noImageLabel: UILabel, nameRecipeLabel: UILabel, nameRecipe: String, ingredientsLabel: UILabel, detailIngredients: String, numberOfLikeLabel: UILabel, numberOfLike: Int, timeLabel: UILabel, time: Int) {
        
        if recipeImage != nil {
            noImageLabel.isHidden = true
            recipeImageView.image = recipeImage
        } else {
            noImageLabel.isHidden = false
            recipeImageView.image = defaultImage
        }
        
        recipeImageView.contentMode = .scaleAspectFill
        nameRecipeLabel.text = nameRecipe
        ingredientsLabel.text = detailIngredients
        numberOfLikeLabel.text = "\(numberOfLike)"
        timeLabel.text = "\(time)min"
    }
}

//MARK: -Favorites Protocol
protocol Favorites {}

extension Favorites {
    
    func toggleHiddenLabel(noImageLabel: UILabel) {
        if noImageLabel.isHidden == true {
            noImageLabel.isHidden = false
        } else {
            noImageLabel.isHidden = true
        }
    }
}

//MARK: -DataService Protocol
protocol DataService {}

extension DataService {
    
    func saveToCoreData(recipe: Recipe) {
        addRecipeToFavorites(recipe: recipe)
        print(Recipe.favoritesRecipes.count)
    }
    
    func remove(recipe: Recipe, row: Int) {
        Recipe.favoritesRecipes.remove(at: row)
        print(Recipe.favoritesRecipes.count)
    }
    
    func addRecipeToFavorites(recipe: Recipe) {
        Recipe.favoritesRecipes.append(recipe)
        print(Recipe.favoritesRecipes.count)
    }
}
