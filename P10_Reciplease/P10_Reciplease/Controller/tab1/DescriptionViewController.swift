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
    
    var recipe: Recipe?
    var coreDataManager: CoreDataManager?
    
    @IBOutlet weak var starButton: UIBarButtonItem!
    
    // MARK: - @IBOutlets
    @IBOutlet weak var nameRecipeLabel: UILabel!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var recipeImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        guard let recipe_ = recipe else { return }
        refreshFavoriteStatus()
        updateRecipeImageView()
        nameRecipeLabel.text = recipe_.label
        let ingredientsLines = recipe_.ingredientLines
        ingredientsTextView.text = ingredientsLines.joined(separator: ", \n")
    }
    
    deinit {
        print("deinit: DescriptionVC")
    }
    
    @IBAction func starButtonAction(_ sender: UIBarButtonItem) {
        guard let recipe = recipe else { return }
        createsOrDeletesCoreDataRecipe(recipe: recipe)
    }
    
    @IBAction func getDirectionsButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "DescriptionToWeb", sender: nil)
    }
    
    func refreshFavoriteStatus() {
        guard let coreDataManager = coreDataManager else { return }
        let favorite = coreDataManager.read().first(where: { recipe -> Bool in
            return recipe.uri == self.recipe?.uri
        })
        if favorite == nil {
            starButton.tintColor = .white
        } else {
            starButton.tintColor = .yellow
        }
    }
    
    func createsOrDeletesCoreDataRecipe(recipe: Recipe) {
        
        guard let coreDataManager = coreDataManager else { return }
        let favoriteRecipe = coreDataManager.read().first(where: { recipe -> Bool in
            return recipe.uri == self.recipe?.uri
        })
        
        if let favoriteRecipe = favoriteRecipe {

            coreDataManager.delete(recipe_: favoriteRecipe)
        } else {
            coreDataManager.create(recipe: recipe)
        }
        refreshFavoriteStatus()
    }
    
    func updateRecipeImageView() {
        recipeImageView.contentMode = .scaleAspectFit
        if let imageURL = recipe?.image {
           recipeImageView.kf.setImage(with: .network(imageURL), placeholder: nil, options: [.cacheOriginalImage, .transition(.fade(0.5)), .forceRefresh], progressBlock: nil, completionHandler: nil)
        } else {
            recipeImageView.image = #imageLiteral(resourceName: "defaultImage")
        }
    }
}


// MARK: - Navigation
extension DescriptionViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DescriptionToWeb", let webVC = segue.destination as? WebViewController {
            webVC.url = recipe?.url
        }
    }
}
