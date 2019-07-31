//
//  CoreDataTest.swift
//
//  Created by macbook pro on 25/07/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

@testable import P10_Reciplease
import XCTest

class CoreDataTest: XCTestCase {
    
    var coreDataManager: CoreDataManager!
    
    let recipe: Recipe = Recipe(label: "label", image: URL(string: "url")!, url: URL(string: "url1")!, uri: URL(string: "Uri")!, ingredientLines: ["ingredients", "lines"], totalTime: 2.0, imageData: UIImage().pngData())
    
    override func setUp() {
        coreDataManager = CoreDataManager(inMemoryType: true)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testCreateEntityShouldDiplayEquivalentValues() {
        
        coreDataManager.create(recipe: recipe)
        
        let favoriteRecipe = coreDataManager.read()
        
        XCTAssertEqual(favoriteRecipe.last?.label, recipe.label)
    }
    
    func testReadEntityShouldDisplayOneRecipe() {
        
        XCTAssertEqual(coreDataManager.read().count, 0)
        
        coreDataManager.create(recipe: recipe)
        
        XCTAssertEqual(coreDataManager.read().count, 1)
    }
    
    func testAddEntityInContextShouldDisplayContextHasChanged() {
        
        XCTAssert(coreDataManager.viewContext.hasChanges == false)
        
        let _ = Recipe_(context: coreDataManager.viewContext)
        
        XCTAssert(coreDataManager.viewContext.hasChanges == true)
    }
    
    // delete an entity should display that the total number of recipes is empty
    func testDeleteEntityShouldDisplayTotalNumberOfRecipeIsEmpty() {
        
        XCTAssert(coreDataManager.read().count == 0)
        
        let recipe_ = Recipe_(context: coreDataManager.viewContext)
        XCTAssert(coreDataManager.read().count == 1)
        
        coreDataManager.delete(recipe_: recipe_)
        XCTAssert(coreDataManager.read().count == 0)
    }
    
    
}

