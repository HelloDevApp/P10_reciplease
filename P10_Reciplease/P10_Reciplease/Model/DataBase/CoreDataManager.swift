//
//  CoreDataManager.swift
//  P10_Reciplease
//
//  Created by macbook pro on 01/07/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    var favoritesRecipes_ = [Recipe_]()
    let container = NSPersistentContainer(name: "P10_Reciplease")
    
    private lazy var persistentContainer: NSPersistentContainer = {
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
    
    init(inMemoryType: Bool = false) {
        if inMemoryType {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            description.shouldAddStoreAsynchronously = false
            container.persistentStoreDescriptions = [description]
        }
    }
    
    func create(recipe: Recipe) {
        let recipe_ = Recipe_(context: viewContext)
        recipe_.label = recipe.label
        recipe_.ingredientLines = recipe.ingredientLines as NSObject
        recipe_.image = recipe.image
        recipe_.url = recipe.url
        recipe_.uri = recipe.uri
        recipe_.totalTime = recipe.totalTime
        recipe_.imageData = recipe.imageData
        viewContext.insert(recipe_)
        update()
    }
    
    func read() -> [Recipe_] {
        let request: NSFetchRequest<Recipe_> = Recipe_.fetchRequest()
        
        do {
            favoritesRecipes_ = try viewContext.fetch(request).reversed()
            print("retrieve Favorites...")
            return favoritesRecipes_
        }
        catch {
            print("no fav")
            return [Recipe_]()
        }
    }
    
    func update() {
        guard viewContext.hasChanges else { return }
        do {
            try viewContext.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
        print("object has been saved in the context.")
    }
    
    func delete(recipe_: Recipe_) {
        viewContext.delete(recipe_)
        favoritesRecipes_ = read()
        update()
    }
}
