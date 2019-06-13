//
//  UserDefaultManager.swift
//  P10_Reciplease
//
//  Created by macbook pro on 13/06/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    
    // MARK: - Properties
    private let _userIngredientskey = "UserIngredient"
    
    // contains the key to get the ingredients saved in userDefaults
    var userIngredientsKey: String {
        return _userIngredientskey
    }
    
    
    // MARK: - Methods
    // updates the array as a parameter with the value retrieved from userDefaults
    func get(to array: inout [String], key: String) {
        array = UserDefaults.standard.array(forKey: key) as? [String] ?? [String]()
    }
    
    // saves the array as a parameter in userdefaults
    func set(to array: [String], key: String) {
        UserDefaults.standard.set(array, forKey: key)
    }
    
    // delete the element of a array and update UserDefaults
    func remove(to array: inout [String], key: String, indexPath: IndexPath) {
        array.remove(at: indexPath.row)
        UserDefaults.standard.set(array, forKey: key)
    }
    
    // delete all elements of an array and update userDefaults
    func removeAll(to array: inout [String], key: String) {
        array.removeAll()
        UserDefaults.standard.set(array, forKey: key)
    }
}
