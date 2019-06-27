//
//  Recipe_CoreData.swift
//  P10_Reciplease
//
//  Created by macbook pro on 26/06/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import CoreData

class Recipe_: NSManagedObject {
    
    static var allRecipes: [Recipe_] {
        let request: NSFetchRequest<Recipe_> = Recipe_.fetchRequest()

        do {
            let favorite = try AppDelegate.viewContext.fetch(request)
            print("retrieve Favorites...")
            return favorite
        }

        catch {
            print("no fav")
            return []
        }
    }

    static func saveContext() {

        do {
            try AppDelegate.viewContext.save()
            print("object has been saved in the context.")
        }

        catch {
            print("error")
        }
    }
}
