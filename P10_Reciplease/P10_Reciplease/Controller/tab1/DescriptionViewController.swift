//
//  DescriptionViewController.swift
//  P10_Reciplease
//
//  Created by macbook pro on 23/05/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit
import Kingfisher
import WebKit

class DescriptionViewController: UIViewController {
    
    var nameRecipe = String()
    var ingredients = String()
    var imageRecipe: UIImage?
    var urlDirections = URL(string: "")
    
    @IBOutlet weak var nameRecipeLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UITextView!
    
    // MARK: - @IBOutlets
    @IBOutlet weak var recipeImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        updateRecipeImageView()
        nameRecipeLabel.text = nameRecipe
        ingredientsLabel.text = ingredients
    }
    
    deinit {
        print("deinit: DescriptionVC")
    }
    @IBAction func getDirectionsButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "DescriptionToWeb", sender: nil)
    }
    
    func updateRecipeImageView() {
        recipeImageView.contentMode = .scaleAspectFit
        if imageRecipe == nil {
            recipeImageView.image = #imageLiteral(resourceName: "defaultImage")
        } else {
            recipeImageView.image = imageRecipe
        }
    }
}


// MARK: - Navigation
extension DescriptionViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DescriptionToWeb", let webVC = segue.destination as? WebViewController {
            webVC.url = urlDirections
        }
    }
}
