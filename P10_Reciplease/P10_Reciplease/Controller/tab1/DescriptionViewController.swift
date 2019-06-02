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
        changeTintColor(barButtonItem: featuredButton, color: UIColor.yellow)
    }
}


// MARK: - Navigation
extension DescriptionViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
