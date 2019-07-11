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
    var imageURL: URL?
    var urlDirections = URL(string: "")
    
    // MARK: - @IBOutlets
    @IBOutlet weak var nameRecipeLabel: UILabel!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var recipeImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        updateRecipeImageView()
        nameRecipeLabel.text = nameRecipe
        ingredientsTextView.text = ingredients
    }
    
    deinit {
        print("deinit: DescriptionVC")
    }
    @IBAction func getDirectionsButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "DescriptionToWeb", sender: nil)
    }
    
    func updateRecipeImageView() {
        recipeImageView.contentMode = .scaleAspectFit
        if let imageURL = imageURL {
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
            webVC.url = urlDirections
        }
    }
}
