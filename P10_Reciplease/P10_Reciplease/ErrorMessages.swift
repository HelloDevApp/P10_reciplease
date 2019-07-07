//
//  ErrorMessages.swift
//  P10_Reciplease
//
//  Created by macbook pro on 20/06/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

enum ErrorMessages: String {
    
    //MARK: - Label Text
    case noImageAvailable = "No image available"
    
    // MARK: - Title
    case error = "Error"
    case sorry = "Sorry!"
    case ok = "Ok"
    case noFavorites = "No favorites"
    
    // MARK: - Messages
    case userIngredientsIsEmpty = "Start by adding ingredients or recipe names to your list"
    case noOtherRecipesFound = "So other recipes found"
    case requestLimitReached = "We're limited to 5 requests per minute. Repeat in one minute..."
    case requestHasFailed = "The request has failed please check again in a few moments."
    case noInternetConnection = "The request has failed... please check your internet connection"
    case favoriteRecipesIsEmpty = "Start by adding recipes as favorites"
    
    
}
