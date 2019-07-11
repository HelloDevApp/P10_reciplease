//
//  ResultViewController.swift
//  P10_Reciplease
//
//  Created by macbook pro on 23/05/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit
import Kingfisher

class ResultViewController: UIViewController, NetworkProtocol {

    var userIngredients = [String]()
    var apiHelper: APIHelper?
    var hits = [Hit]()
    var favorite = [Recipe]()
    var rowSelect: Int = 0
    
    //MARK: - @IBOutlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    deinit {
        print("deinit: ResultVC")
    }
    
    private func saveRecipe(label: String, ingredientsLines: [String], image: URL?, url: URL, uri: URL, totalTime: Double) {
        var canSave = true
        for favoriteRecipe in CoreDataManager.shared.fetchRecipes() {
            if favoriteRecipe.uri != uri {
                canSave = true
            } else {
                canSave = false
                break
            }
        }
        
        switch canSave {
        case true:
            let recipe = Recipe_(context: CoreDataManager.shared.viewContext)
            recipe.label = label
            recipe.ingredientLines = ingredientsLines as NSObject
            recipe.totalTime = totalTime
            recipe.image = image
            recipe.url = url
            recipe.uri = uri
            CoreDataManager.shared.saveContext()
            presentAlert(titleAlert: .itsOK, messageAlert: .recipeAddedToFavorites, actionTitle: .ok, statusCode: nil, completion: nil)
        case false:
            presentAlert(titleAlert: .sorry, messageAlert: .recipeAlreadyInFavorites, actionTitle: .ok, statusCode: nil, completion: nil)
            break
        }
        
    }
}

// MARK: - Navigation
extension ResultViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "DescriptionVC":
            guard let descriptionVC = segue.destination as? DescriptionViewController else { return }
            guard let recipe = hits[rowSelect].recipe else { return }
            guard let recipeImageURL = recipe.image else { return }
            
            descriptionVC.urlDirections = recipe.url
            descriptionVC.nameRecipe = recipe.label
            descriptionVC.ingredients = recipe.ingredientLines.joined(separator: ", \n")
            descriptionVC.imageURL = recipeImageURL
            
        default:
            return
        }
    }
}

// MARK: - TableView
extension ResultViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundColor = #colorLiteral(red: 0.1219023839, green: 0.129180491, blue: 0.1423901618, alpha: 1)
        tableView.separatorStyle = .none
        return hits.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let favoritesAction = UITableViewRowAction(style: .default, title: "➕Favorites", handler: { [weak self] (action, indexPath) in
            
            guard let self = self else { return }
            guard let recipe = self.hits[indexPath.row].recipe else { return }
            
            self.saveRecipe(label: recipe.label, ingredientsLines: recipe.ingredientLines, image: recipe.image, url: recipe.url, uri: recipe.uri, totalTime: recipe.totalTime)
            self.favorite.append(recipe)
        })
        
        favoritesAction.backgroundColor = UIColor.darkText
        return [favoritesAction]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = tableView.frame.height / 3
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as? ResultTableViewCell {
            fillCell(cell, with: hits, indexPath: indexPath)
            return cell
        }
        let cellStandard = UITableViewCell()
        return cellStandard
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let offset: CGPoint = scrollView.contentOffset
        let bounds: CGRect = scrollView.bounds
        let size: CGSize = scrollView.contentSize
        let inset: UIEdgeInsets = scrollView.contentInset
        let y: CGFloat = offset.y + bounds.size.height - inset.bottom
        let h: CGFloat = size.height
        
        let reloadDistance: CGFloat = 1
        
        if (y > h + reloadDistance) {
            launchCall(controller: self)
        }
    }
    
    private func fillCell(_ cell: ResultTableViewCell, with hits: [Hit], indexPath: IndexPath) {
        
        let hit = hits[indexPath.row]
        guard let recipe = hit.recipe else { return }
        
        cell.nameRecipeLabel.text = "\(indexPath.row + 1) " + recipe.label
        cell.ingredientsLabel.text = recipe.ingredientLines.joined(separator: ", ")
        cell.timeLabel.text = String(recipe.totalTime)
        
        if let url = recipe.image {
            cell.recipeImageView.kf.setImage(with: .network(url), placeholder: nil, options: [.cacheOriginalImage, .transition(.fade(0.5)), .forceRefresh], progressBlock: nil, completionHandler: nil)
            cell.noImageLabel.isHidden = true
        } else {
            cell.recipeImageView.image = #imageLiteral(resourceName: "defaultImage")
            cell.noImageLabel.isHidden = false
            cell.noImageLabel.text = "No image available"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowSelect = indexPath.row
        performSegue(withIdentifier: "DescriptionVC", sender: nil)
    }
}
