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
    
    //MARK: - SearchVC
    var userIngredients = [String]()
    
    //MARK: - ResultVC
    var apiHelper: APIHelper?
    var hits = [Hit]()
    
    //MARK: - FavoritesVC
    var favorite = [Recipe]()
    
    //MARK: - DescriptionVC
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
    
    private func saveRecipe(label: String, ingredientsLines: [String], image: URL?, url: URL, totalTime: Double) {
        
        let recipe = Recipe_(context: CoreDataManager.shared.viewContext)
        recipe.label = label
        recipe.ingredientLines = ingredientsLines as NSObject
        recipe.totalTime = totalTime
        recipe.image = image
        recipe.url = url
        
        CoreDataManager.shared.saveContext()
    }
    
    func loadMoreRecipes(indexPath: Int) {
        print(indexPath)
        guard indexPath == hits.count - 1 else { return }
        guard let apiHelper = apiHelper else { return }
        apiHelper.from = hits.count
        apiHelper.to = (hits.count) + 10
        
        startAnimatingActivityIndicator()
        
        apiHelper.getRecipe(userIngredients: userIngredients, callback: { [weak self] (apiResult, statusCode)  in
            guard let apiResult = apiResult else {

                apiHelper.from = self?.hits.count ?? 1
                apiHelper.to = (self?.hits.count ?? 1) + 10
                
                self?.switchStatusCode(statusCode: statusCode)
                
                if let apiHelper = self?.apiHelper {
                    apiHelper.from = self?.hits.count ?? 1
                    apiHelper.to = (self?.hits.count ?? 1) + 10
                }
                self?.stopAnimatingActivityIndicator()
                return
            }
            guard !apiResult.hits.isEmpty else {
                self?.parent?.presentAlert(titleAlert: .sorry, messageAlert: .noOtherRecipesFound, actionTitle: .ok, statusCode: nil, completion: nil)
                if let apiHelper = self?.apiHelper {
                    apiHelper.from = self?.hits.count ?? 1
                    apiHelper.to = (self?.hits.count ?? 1) + 10
                }
                self?.stopAnimatingActivityIndicator()
                return
            }
            self?.stopAnimatingActivityIndicator()
            self?.hits.append(contentsOf: apiResult.hits)
            self?.tableView.reloadData()
        })
    }
    
    func switchStatusCode(statusCode: Int?) {
        guard let statusCode = statusCode else { return }
        switch statusCode {
        case 200:
            stopAnimatingActivityIndicator()
        case 400:
            parent?.presentAlert(titleAlert: .error, messageAlert: .requestHasFailed, actionTitle: .ok, statusCode: statusCode, completion: nil)
            stopAnimatingActivityIndicator()
        case 401:
            parent?.presentAlert(titleAlert: .error, messageAlert: .requestLimitReached, actionTitle: .ok, statusCode: statusCode, completion: nil)
            stopAnimatingActivityIndicator()
        case 402...499:
            parent?.presentAlert(titleAlert: .error, messageAlert: .requestHasFailed, actionTitle: .ok, statusCode: statusCode, completion: nil)
            stopAnimatingActivityIndicator()
        case 500...599:
            parent?.presentAlert(titleAlert: .error, messageAlert: .requestHasFailed, actionTitle: .ok, statusCode: statusCode, completion: nil)
            stopAnimatingActivityIndicator()
        default:
            stopAnimatingActivityIndicator()
        }
    }
    
    func startAnimatingActivityIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopAnimatingActivityIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
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
            self.saveRecipe(label: recipe.label, ingredientsLines: recipe.ingredientLines, image: recipe.image, url: recipe.url, totalTime: recipe.totalTime)
            
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        loadMoreRecipes(indexPath: indexPath.row)
    }
    
    func fillCell(_ cell: ResultTableViewCell, with hits: [Hit], indexPath: IndexPath) {
        let hit = hits[indexPath.row]
        guard let recipe = hit.recipe else { return }
        cell.nameRecipeLabel.text = "\(indexPath.row + 1) " + recipe.label
        cell.ingredientsLabel.text = recipe.ingredientLines.joined(separator: ", ")
        let timeString = String(recipe.totalTime)
        cell.timeLabel.text = timeString
        if let url = recipe.image {
            cell.recipeImageView.kf.setImage(with: .network(url), placeholder: nil, options: [.cacheOriginalImage, .transition(.fade(1))], progressBlock: nil, completionHandler: nil)
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
