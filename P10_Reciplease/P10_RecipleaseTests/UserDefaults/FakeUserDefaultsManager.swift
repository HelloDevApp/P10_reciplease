//
//  FakeUserDefaultsManager.swift
//  P10_RecipleaseTests
//
//  Created by macbook pro on 15/07/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

@testable import P10_Reciplease
import Foundation

class FakeUserDefaultsManager: UserDefaultsManager {
    
    var key = String()
    var array = [String]()
    
    override func removeObject(forKey defaultName: String) {
        super.removeObject(forKey: defaultName)
        self.key = defaultName
    }
    
    override func get(to array: inout [String], key: String) {
        super.get(to: &array, key: key)
        array = self.array(forKey: key) as? [String] ?? []
        self.key = key
        self.array = array
    }
    
    override func set(to array: [String], key: String) {
        super.set(to: array, key: key)
        self.key = key
        self.array = array
    }
    
    override func remove(to array: inout [String], key: String, indexPath: IndexPath) {
        super.remove(to: &array, key: key, indexPath: indexPath)
        self.key = key
        self.array = array
    }
    
    override func removeAll(to array: inout [String], key: String) {
        super.removeAll(to: &array, key: key)
        self.key = key
        self.array = array
    }
}
