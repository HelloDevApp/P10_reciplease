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
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    // MARK: - Life Cycle App Methods
    override func viewWillAppear(_ animated: Bool) {
        guard let recipe_ = recipe else { return }
        refreshFavoriteStatus()
        updateRecipeImageView()
        nameRecipeLabel.text = recipe_.label
        let ingredientsLines = recipe_.ingredientLines
        ingredientsTextView.text = ingredientsLines.joined(separator: ", \n")
        
        let timeConvert = String(format: "%.2f", recipe_.totalTime / 60)
            .replacingOccurrences(of: ".", with: "h")
        
        totalTimeLabel.text = timeConvert
    }
    
    deinit {
        ImageCache.default.clearMemoryCache()
        print("deinit: DescriptionVC")
    }
    
    // MARK: - @IBActions
    @IBAction func starButtonAction(_ sender: UIBarButtonItem) {
        guard var recipe = recipe else { return }
        createsOrDeletesCoreDataRecipe(recipe: &recipe)
    }
    
    @IBAction func getDirectionsButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "DescriptionToWeb", sender: nil)
    }
    
    // MARK: - Methods
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
    
    func createsOrDeletesCoreDataRecipe(recipe: inout Recipe) {
        
        guard let coreDataManager = coreDataManager else { return }
        let favoriteRecipe = coreDataManager.read().first(where: { recipe -> Bool in
            return recipe.uri == self.recipe?.uri
        })
        
        if let favoriteRecipe = favoriteRecipe {

            coreDataManager.delete(recipe_: favoriteRecipe)
        } else {
            
            guard let imageRecipe = recipeImageView.image else { return }
            recipe.imageData = imageRecipe.pngData()
            coreDataManager.create(recipe: recipe)
        }
        refreshFavoriteStatus()
    }
    
    func updateRecipeImageView() {
        
        recipeImageView.contentMode = .scaleAspectFit
        
        guard let recipe = recipe, let urlImage = recipe.image else {
            self.recipeImageView.image = Constants.noImage
            return
        }
        
        // retrieve image in memory cache
        KingfisherManager.shared.cache.retrieveImage(forKey: "\(urlImage)") { (result) in
            switch result {
            case .success(let imageCacheResult):
                DispatchQueue.main.async {
                    self.recipeImageView.image = imageCacheResult.image
                }
            case .failure(_):
                self.recipeImageView.image = Constants.noImage
            }
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
