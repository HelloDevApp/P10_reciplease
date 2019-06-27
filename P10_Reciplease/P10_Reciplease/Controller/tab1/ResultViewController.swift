//
//  ResultViewController.swift
//  P10_Reciplease
//
//  Created by macbook pro on 23/05/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit
import Kingfisher

class ResultViewController: UIViewController {
    //MARK: - SearchVC
    var userIngredients = [String]()
    //MARK: - ResultVC
    var hits = [Hit]()
    //MARK: - FavoritesVC
    var favorite = [Recipe]()
  //  var imageFavorite = [UIImage]()
    var rowSelect: Int = 0
    
    let cache = ImageCache.default
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var apiHelper: APIHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
//        cache.memoryStorage.config.expiration = .seconds(60)
    }
    
    deinit {
        print("deinit: ResultVC")
        cache.clearMemoryCache()
    }
    
}

// MARK: - Navigation
extension ResultViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DescriptionVC" {
            guard let descriptionVC = segue.destination as? DescriptionViewController else { return }
            guard let recipe = hits[rowSelect].recipe else { return }
            guard let nameRecipe = recipe.label else { return }
            guard let ingredients = recipe.ingredientLines else { return }
            guard let urlDirections = recipe.url else { return }
            guard let recipeImageURL = recipe.image else { return }
            
            
            cache.retrieveImage(forKey: recipeImageURL.absoluteString) { [weak self] (ImageCacheResult) in
                guard self != nil else { return }
                switch ImageCacheResult {
                case .success(let success):
                    guard let image = success.image else { return }
                    descriptionVC.imageRecipe = image
                case .failure(_):
                    descriptionVC.imageRecipe = nil
                    print("this image is not in the kf cache")
                    break
                }
            }
            descriptionVC.urlDirections = urlDirections
            descriptionVC.nameRecipe = nameRecipe
            descriptionVC.ingredients = ingredients.joined(separator: ", \n")
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
            // add actions (save to favorites list) and core data
            guard let recipe = self.hits[indexPath.row].recipe else { return }
            
            self.favorite.append(recipe)
//            self.imageFavorite.append(image)
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
            print(indexPath.row)
            fillCell(cell, with: hits, indexPath: indexPath)
            loadMoreRecipes(numberOfRow: indexPath.row)
            return cell
        }
        let cellStandard = UITableViewCell()
        return cellStandard
    }
    
    func fillCell(_ cell: ResultTableViewCell, with hits: [Hit], indexPath: IndexPath) {
        let hit = hits[indexPath.row]
        guard let recipe = hit.recipe else { return }
        guard let url = recipe.image else { return }
        cell.recipeImageView.kf.setImage(with: .network(url), placeholder: nil, options: [.cacheOriginalImage, .transition(.fade(3))], progressBlock: nil, completionHandler: nil)
        cell.nameRecipeLabel.text = "\(indexPath.row)" + recipe.label!
        cell.ingredientsLabel.text = recipe.ingredientLines?.joined(separator: ", ") ?? ""
        guard let totalTime = recipe.totalTime else { return }
        let timeString = String(totalTime)
        cell.timeLabel.text = timeString
    }
    
    func loadMoreRecipes(numberOfRow: Int) {
        print(numberOfRow)
        guard numberOfRow == hits.count - 1 else { return }
        guard let apiHelper = apiHelper else { return }
        apiHelper.from = apiHelper.to + 1
        apiHelper.to = apiHelper.from + 9
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        apiHelper.getRecipe(userIngredients: userIngredients, callback: { [weak self] (apiResult, statusCode)  in
            guard let self = self else { return }
            guard let apiResult = apiResult, !apiResult.hits.isEmpty else {
                guard let statusCode = statusCode else { return }
                switch statusCode {
                case 401:
                    self.presentAlert(titleAlert: .error, messageAlert: .requestLimitReached, actionTitle: .ok, statusCode: statusCode)
                    print("limit request")
                    print("error: \(statusCode)")
                default:
                    self.presentAlert(titleAlert: .error, messageAlert: .requestHasFailed, actionTitle: .error, statusCode: statusCode)
                    print("error: \(statusCode)")
                }
                if let apiHelper = self.apiHelper {
                    apiHelper.from -= 10
                    apiHelper.to -= 10
                }
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                return
            }
            self.hits.append(contentsOf: apiResult.hits)
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowSelect = indexPath.row
        performSegue(withIdentifier: "DescriptionVC", sender: nil)
    }
}
