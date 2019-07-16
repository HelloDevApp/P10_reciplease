//
//  CoreDataManager.swift
//  P10_Reciplease
//
//  Created by macbook pro on 01/07/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    var favoritesRecipes = [Recipe_]()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "P10_Reciplease")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func fetchRecipes() -> [Recipe_] {
        
        let request: NSFetchRequest<Recipe_> = Recipe_.fetchRequest()
        
        do {
            favoritesRecipes = try viewContext.fetch(request).reversed()
            print("retrieve Favorites...")
            return favoritesRecipes
        }
            
        catch {
            print("no fav")
            return []
        }
    }
    
    func saveContext() {
        
        guard viewContext.hasChanges else { return }
        do {
            try viewContext.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
        print("object has been saved in the context.")
    }
}
