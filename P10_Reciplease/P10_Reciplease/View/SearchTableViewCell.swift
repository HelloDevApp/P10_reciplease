//
//  IngredientsTableViewCell.swift
//  P10_Reciplease
//
//  Created by macbook pro on 23/05/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var ingredientsLabel: UILabel!
    
    func setTitle(label: UILabel, text: String) {
        label.text = text
    }
}
