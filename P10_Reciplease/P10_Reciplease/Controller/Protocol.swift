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
        
        if recipeImageView.image != nil {
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
protocol Favorites {
}

extension Favorites {
    
    func toggleLabel(noImageLabel: UILabel) {
        if noImageLabel.isHidden == true {
            noImageLabel.isHidden = false
        } else {
            noImageLabel.isHidden = true
        }
    }
    
    func changeTintColor(barButtonItem: UIBarButtonItem) {
        
        if barButtonItem.tintColor == UIColor.white {
            barButtonItem.tintColor = UIColor.yellow
        } else {
            barButtonItem.tintColor = UIColor.white
        }
    }
    
    func save(recipe: Recipe) {
        RecipeHelper.favoritesRecipes.append(recipe)
    }
    
    func remove(row: Int) {
        RecipeHelper.favoritesRecipes.remove(at: row)
    }
}
