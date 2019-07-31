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
    
    var rowSelect: Int?
    var recipe: Recipe?
    var coreDataManager = (UIApplication.shared.delegate as? AppDelegate)?.coreDataManager
    
    @IBOutlet weak var starButton: UIBarButtonItem!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var nameRecipeLabel: UILabel!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshFavoriteStatus()
    }
    
    @IBAction func starButtonAction(_ sender: UIBarButtonItem) {
        guard let recipe = recipe else { return }
        createsOrDeletesCoreDataRecipe(recipe: recipe)
    }
    
    @IBAction func getDirectionButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "FavoritesDescriptionToWeb", sender: nil)
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
        let favorite = coreDataManager.read().first(where: { recipe -> Bool in
            return recipe.uri == self.recipe?.uri
        })
        
        if let favorite = favorite {
            coreDataManager.delete(recipe_: favorite)
        } else {
            coreDataManager.create(recipe: recipe)
        }
        refreshFavoriteStatus()
    }
    
    func setup() {
        guard let recipe = recipe else { return }
        nameRecipeLabel.text = recipe.label
        ingredientsTextView.text = recipe.ingredientLines.joined(separator: ",\n")
        recipeImageView.contentMode = .scaleAspectFit
        
        let timeConvert = String(format: "%.2f", recipe.totalTime / 60).replacingOccurrences(of: ".", with: "h")
            totalTimeLabel.text = timeConvert
        guard let imageData = recipe.imageData else {
            print("return descriptionFav ImageData == nil")
            recipeImageView.image = Constants.noImage
            return
        }
        recipeImageView.image = UIImage(data: imageData)
    }
}

// MARK: - Navigation
extension FavoritesDescriptionViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "FavoritesDescriptionToWeb" else { return }
        if let webVC = segue.destination as? FavoritesWebViewController {
            guard let recipe = recipe else { return }
            webVC.url = recipe.url
        }
    }
}
