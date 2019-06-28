//
//  FeaturedRecipeViewController.swift
//  P10_Reciplease
//
//  Created by macbook pro on 30/05/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher

class FavoritesResultViewController: UIViewController {
    
    lazy var refresher = UIRefreshControl()
    var favoritesRecipes = [Recipe_]()
    var rowSelect = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noFavoritesLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        initRefresher()
        fetchRecipes()
        tableView.reloadData()
    }
    
    deinit {
        print("deinit: FavoritesVC")
    }
    
}


// MARK: - Navigation
extension FavoritesResultViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "FavoritesToFavoritesDescription" else { return }
        guard let favoritesDescriptionVC = segue.destination as? FavoritesDescriptionViewController else { return }
        favoritesDescriptionVC.recipe = favoritesRecipes[rowSelect]
    }
}

// MARK: - TableView
extension FavoritesResultViewController: UITableViewDataSource, UITableViewDelegate {
    
    fileprivate func initRefresher() {
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refresher
        } else {
            tableView.addSubview(refresher)
        }
        
        refresher.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func refreshTableView() {
        tableView.reloadData()
        self.refresher.endRefreshing()
    }
    
    func fetchRecipes() {
        favoritesRecipes = Recipe_.allRecipes.reversed()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesRecipes.count
    }
    
    fileprivate func changeSeparatorStyle(_ tableView: UITableView) {
        switch favoritesRecipes.count {
        case 0:
            noFavoritesLabel.isHidden = false
            tableView.separatorStyle = .none
        case 1:
            tableView.separatorStyle = .none
            noFavoritesLabel.isHidden = true
        case 2...Int.max:
            tableView.separatorStyle = .singleLine
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.rowHeight = tableView.frame.height / 3
        changeSeparatorStyle(tableView)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as? ResultTableViewCell else { return UITableViewCell() }
        fillCell(cell, with: favoritesRecipes, indexPath: indexPath)
        
        return cell
    }
    
    func fillCell(_ cell: ResultTableViewCell, with recipes: [Recipe_?], indexPath: IndexPath) {
        
        guard let recipe = recipes[indexPath.row] else { return }
        
        let ingredientLines = recipe.ingredientLines as? [String]
        let ingredients = ingredientLines?.joined(separator: ", ") ?? "Ingredients not available"
        let nameRecipe = recipe.label ?? "Name not available"
        let timeRecipe = recipe.totalTime
        if let imageURL = recipe.image {
            updateImage(cell: cell, urlImage: imageURL, indexPath: indexPath)
        }
        
        updateNameRecipeLabel(cell: cell, nameRecipe: nameRecipe)
        updateIngredientsLabel(cell: cell, ingredients: ingredients)
        updateTimeLabel(cell: cell, time: timeRecipe)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            AppDelegate.viewContext.delete(favoritesRecipes[indexPath.row])
            // refresh count of favoritesRecipes to display correct tableView
            favoritesRecipes = Recipe_.allRecipes
            
            do {
                try AppDelegate.viewContext.save()
                print("saved context done.")
            } catch {
                   print("saved context problem.")
            }
            tableView.reloadData()
            print("favoritesRecipes:" + "\(favoritesRecipes.count)" + "\(favoritesRecipes)")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowSelect = indexPath.row
        performSegue(withIdentifier: "FavoritesToFavoritesDescription", sender: nil)
    }
    
    func updateNameRecipeLabel(cell: ResultTableViewCell, nameRecipe: String) {
        cell.nameRecipeLabel.text = nameRecipe
    }
    
    func updateIngredientsLabel(cell: ResultTableViewCell, ingredients: String) {
        cell.ingredientsLabel.text = ingredients
    }
    
    func updateImage(cell: ResultTableViewCell, urlImage: URL, indexPath: IndexPath) {
        
        cell.noImageLabel.isHidden = true
        cell.recipeImageView.kf.setImage(with: .network(urlImage), placeholder: nil, options: [.cacheOriginalImage, .transition(.flipFromTop(1))], progressBlock: nil, completionHandler: nil)
        print("image loaded.")
    }
    
    func updateTimeLabel(cell: ResultTableViewCell, time: Double?) {
        if let timerecipe = time {
            let time = String(timerecipe)
            cell.timeLabel.text = time
        }
    }
}
