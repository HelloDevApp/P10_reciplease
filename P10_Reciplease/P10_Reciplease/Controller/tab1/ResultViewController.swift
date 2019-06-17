//
//  ResultViewController.swift
//  P10_Reciplease
//
//  Created by macbook pro on 23/05/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    var hits = [Hit]()
    var favorite = [Recipe]()
    var imageFavorite = [UIImage]()
    var imageRecipe = [UIImage]()
    var userIngredients = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    var apiHelper: APIHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
}

// MARK: - Navigation
extension ResultViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
        let favoritesAction = UITableViewRowAction(style: .default, title: "➕Favorites", handler: { (action, indexPath) in
            // add actions (save to favorites list) and core data
            guard let recipe = self.hits[indexPath.row].recipe else { return }
            let image = self.imageRecipe[indexPath.row]
            self.favorite.append(recipe)
            self.imageFavorite.append(image)
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
            loadMoreRecipes(numberOfRow: indexPath.row)
            return cell
        }
        let cellStandard = UITableViewCell()
        return cellStandard
    }
    
    func fillCell(_ cell: ResultTableViewCell, with hits: [Hit], indexPath: IndexPath) {
        let hit = hits[indexPath.row]
        guard let recipe = hit.recipe else { return }
        getImage(cell: cell, hit: hit)
        cell.nameRecipeLabel.text = recipe.label
        cell.ingredientsLabel.text = recipe.ingredientLines?.joined(separator: ", ") ?? ""
        guard let totalTime = recipe.totalTime else { return }
        let timeString = String(totalTime)
        cell.timeLabel.text = timeString
    }
    
    func getImage(cell: ResultTableViewCell, hit: Hit) {
        guard let urlImage = hit.recipe?.image else { return }
        if let apiHelper = apiHelper {
            apiHelper.getImage(url: urlImage) { (image) in
                cell.noImageLabel.isHidden = true
                cell.recipeImageView.image = image
                cell.recipeImageView.contentMode = .scaleAspectFill
                cell.recipeImageView.alpha = 0.7
            }
        }
    }
    
    func loadMoreRecipes(numberOfRow: Int) {
        if numberOfRow == hits.count - 1 {
            guard let apiHelper = apiHelper else { return }
            apiHelper.from = apiHelper.to + 1
            apiHelper.to = apiHelper.from + 9
            
            apiHelper.getRecipe(userIngredients: userIngredients, callback: { (apiResult, statusCode)  in
                guard let apiResult = apiResult, !apiResult.hits.isEmpty else {
                    guard let statusCode = statusCode else { return }
                    switch statusCode {
                    case 401:
                        print("limit request")
                    default:
                        print("error: \(statusCode)")
                    }
                    if let apiHelper = self.apiHelper {
                        apiHelper.from = apiHelper.to - 1
                        apiHelper.to = apiHelper.from - 9
                    }
                    return
                    
                }
                self.hits.append(contentsOf: apiResult.hits)
                self.tableView.reloadData()
            })
        }
    }
}
