//
//  ResultTableViewCell.swift
//  P10_Reciplease
//
//  Created by macbook pro on 24/05/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    @IBOutlet weak var nameRecipeLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var numberOfLike: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var noImageLabel: UILabel!
    
    let defaultImage = #imageLiteral(resourceName: "defaultImage")
    
    func configure(image: UIImage?, nameRecipe: String, detailIngredients: String, numberOflike: Int, time: Int) {
        
        if imageView?.image != nil {
            noImageLabel.isHidden = true
            recipeImageView.image = image
        } else {
            noImageLabel.isHidden = false
            recipeImageView.image = defaultImage
        }
        
        recipeImageView.contentMode = .scaleAspectFill
        nameRecipeLabel.text = nameRecipe
        ingredientsLabel.text = detailIngredients
        self.numberOfLike.text = "\(numberOflike)"
        timeLabel.text = "\(time)min"
    }
}
