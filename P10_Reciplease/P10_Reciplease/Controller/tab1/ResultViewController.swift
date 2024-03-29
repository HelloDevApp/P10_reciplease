//
//  ResultViewController.swift
//  P10_Reciplease
//
//  Created by macbook pro on 23/05/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import UIKit
import Kingfisher

class ResultViewController: NetworkController {

    // MARK: - Properties
    var userIngredients = [String]()
    var apiHelper: APIHelper?
    var hits = [Hit]()
    var favorite = [Recipe]()
    var rowSelect: Int = 0
    
    private var coreDataManager: CoreDataManager {
        guard let cdm = (UIApplication.shared.delegate as? AppDelegate)?.coreDataManager else { return CoreDataManager() }
        return cdm
    }
    
    //MARK: - @IBOutlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Life Cycle App Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    deinit {
        ImageCache.default.clearMemoryCache()
        print("deinit: ResultVC")
    }
    
    
    // MARK: - Methods
    func loadMoreRecipes() {
        updateFromAndToForNextCall(apiHelper: apiHelper, hits: hits)
        guard let apiHelper = apiHelper else { return }
        
        startActivityIndicator(controller: self)
        
        apiHelper.getRecipe(userIngredients: userIngredients, callback: { [weak self] (apiResult, errorNetwork)  in
            
            guard let self = self else { return }
            guard let apiResult = apiResult else {
                self.switchErrorNetworkToPresentAlert(errorNetwork: errorNetwork, hitsIsEmpty: true)
                self.stopActivityIndicator(controller: self)
                return
            }
            
            if self.hits.isEmpty && apiResult.hits.isEmpty {
                self.switchErrorNetworkToPresentAlert(errorNetwork: .noRecipeFound, hitsIsEmpty: true)
            } else {
               self.switchErrorNetworkToPresentAlert(errorNetwork: errorNetwork, hitsIsEmpty: false)
            }
            
            self.hits.append(contentsOf: apiResult.hits)
            self.tableView.reloadData()
            self.stopActivityIndicator(controller: self)
        })
    }
    
    private func saveRecipe(recipe: Recipe) {
        var canSave = true
        for favoriteRecipe in coreDataManager.read() {
            if favoriteRecipe.uri != recipe.uri {
                canSave = true
            } else {
                canSave = false
                break
            }
        }
        
        switch canSave {
        case true:
            coreDataManager.create(recipe: recipe)
            parent?.presentAlert(titleAlert: .itsOK, messageAlert: .recipeAddedToFavorites, actionTitle: .ok, completion: nil)
        case false:
            parent?.presentAlert(titleAlert: .sorry, messageAlert: .recipeAlreadyInFavorites, actionTitle: .ok, completion: nil)
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
            
            descriptionVC.coreDataManager = coreDataManager
            descriptionVC.recipe = recipe
            
        default:
            return
        }
    }
}

// MARK: - TableView
extension ResultViewController: UITableViewDataSource, UITableViewDelegate {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        loadView()
        changeSizeCell(tableView: tableView)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundColor = #colorLiteral(red: 0.1219023839, green: 0.129180491, blue: 0.1423901618, alpha: 1)
        tableView.separatorStyle = .none
        changeSizeCell(tableView: tableView)
        return hits.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let favoritesAction = UITableViewRowAction(style: .default, title: "➕Favorites", handler: { [weak self] (action, indexPath) in
            
            guard let self = self else { return }
            
            guard var recipe = self.hits[indexPath.row].recipe else { return }
            
            guard let cell = tableView.cellForRow(at: indexPath) as? ResultTableViewCell else { return }
            
            guard let imageRecipe = cell.recipeImageView.image else { return }
            recipe.imageData = imageRecipe.pngData()
            self.saveRecipe(recipe: recipe)
            self.favorite.append(recipe)
            
        })
        
        favoritesAction.backgroundColor = UIColor.darkText
        return [favoritesAction]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
            loadMoreRecipes()
        }
    }
    
    private func fillCell(_ cell: ResultTableViewCell, with hits: [Hit], indexPath: IndexPath) {
        
        let hit = hits[indexPath.row]
        guard let recipe = hit.recipe else { return }
        
        cell.nameRecipeLabel.text = "\(indexPath.row + 1) " + recipe.label
        cell.ingredientsLabel.text = recipe.ingredientLines.joined(separator: ", ")
        
        let timeConvert = String(format: "%.2f", recipe.totalTime / 60)
            .replacingOccurrences(of: ".", with: "h")
        
        cell.timeLabel.text = String(timeConvert)
        
        if let url = recipe.image {
            cell.noImageLabel.isHidden = true
            cell.recipeImageView.kf.setImage(with: .network(url), placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image) in
                switch image {
                case .success(let retrieveImageResult):
                    ImageCache.default.store(retrieveImageResult.image, forKey: "\(url)")
                    print("image: \(retrieveImageResult.source) stored in imageCache ok !")
                case .failure:
                    cell.recipeImageView.image = Constants.noInternetImage
                    print("failure downloading image !")
                }
            })
        } else {
            cell.recipeImageView.image = Constants.noImage
            cell.noImageLabel.isHidden = false
            cell.noImageLabel.text = ErrorMessages.noImageAvailable.rawValue
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowSelect = indexPath.row
        performSegue(withIdentifier: "DescriptionVC", sender: nil)
    }
}
