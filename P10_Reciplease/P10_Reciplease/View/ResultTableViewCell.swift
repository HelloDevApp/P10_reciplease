//
//  ResultTableViewCell.swift
//  P10_Reciplease
//
//  Created by macbook pro on 24/05/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell, ResultCell {

    @IBOutlet weak var nameRecipeLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var numberOfLike: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var noImageLabel: UILabel!
    
    let defaultImage = #imageLiteral(resourceName: "defaultImage")
    
}
