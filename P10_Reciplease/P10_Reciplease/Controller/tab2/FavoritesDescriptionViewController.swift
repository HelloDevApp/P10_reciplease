//
//  FeaturedDescriptionViewController.swift
//  P10_Reciplease
//
//  Created by macbook pro on 30/05/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit
import Kingfisher

class FavoritesDescriptionViewController: UIViewController {
    
    var recipe: Recipe_?
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var nameRecipeLabel: UILabel!
    @IBOutlet weak var ingredientsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func getDirectionButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "FavoritesDescriptionToWeb", sender: nil)
    }
    
    func setup() {
        guard let recipe = recipe else { return }
        nameRecipeLabel.text = recipe.label
        guard let ingredients = recipe.ingredientLines as? [String] else  { return }

        ingredientsTextView.text = ingredients.joined(separator: ",\n")
        recipeImageView.contentMode = .scaleAspectFit
        if let urlImage = recipe.image {
            recipeImageView.kf.setImage(with: .network(urlImage), placeholder: nil, options: [.cacheOriginalImage, .transition(.fade(0.5)), .forceRefresh], progressBlock: nil, completionHandler: nil)
        } else {
            recipeImageView.image = #imageLiteral(resourceName: "defaultImage")
        }
        
    }
}

// MARK: - Navigation
extension FavoritesDescriptionViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "FavoritesDescriptionToWeb" else { return }
        if let webVC = segue.destination as? FavoritesWebViewController {
            guard let recipe = recipe, let url = recipe.url else { return }
            webVC.url = url
        }
    }
}
