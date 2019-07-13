//
//  P10_RecipleaseTests.swift
//  P10_RecipleaseTests
//
//  Created by macbook pro on 21/05/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

@testable import P10_Reciplease
import XCTest

class P10_RecipleaseTests: XCTestCase {
    
    let fakeResponseData = FakeResponseData()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func createFakeResponseAndFakeSession(data: Data?, response: HTTPURLResponse?, error: Error?) -> FakeAPISession {
        let fakeResponse = FakeResponse(data: data, response: response, error: error)
        let fakeSession = FakeAPISession(fakeResponse: fakeResponse)
        return fakeSession
    }
    
    func createAPIHelper(data: Data?, response: HTTPURLResponse?, error: Error?) -> APIHelper {
        let fakeSession = createFakeResponseAndFakeSession(data: data, response: response, error: error)
         let apiHelper = APIHelper(session: fakeSession)
        return apiHelper
    }
    
    // Alamofire
    func testGetRecipesShouldPostFailedCallbackIfError() {
        let apiHelper = createAPIHelper(data: nil, response: nil, error: fakeResponseData.error)
        
        apiHelper.getRecipe(userIngredients: []) { (apiResult, errorNetwork) in
            XCTAssertNil(apiResult)
            XCTAssertEqual(errorNetwork, ErrorNetwork.requestHasFailed)
        }
    }
    
    func testGetRecipesShouldPostFailedCallbackIfIncorrectData() {
        let apiHelper = createAPIHelper(data: fakeResponseData.incorrectJSON, response: fakeResponseData.responseOK, error: nil)
        
        apiHelper.getRecipe(userIngredients: []) { (apiResult, errorNetwork) in
            XCTAssertNil(apiResult)
            XCTAssertEqual(errorNetwork, ErrorNetwork.wrongJSON)
        }
    }
    
    func testGetRecipesShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let apiHelper = createAPIHelper(data: fakeResponseData.jsonOK, response: fakeResponseData.responseOK, error: nil)
        
        apiHelper.getRecipe(userIngredients: []) { (apiResult, errorNetwork) in
            XCTAssert(!apiResult!.hits.isEmpty)
            XCTAssertEqual(errorNetwork, ErrorNetwork.noError)
        }
    }
    
    func testGetRecipesShouldPostSuccessCallbackWithEmptyRecipes() {
        let apiHelper = createAPIHelper(data: fakeResponseData.jsonWithEmpyRecipes, response: fakeResponseData.responseOK, error: nil)
        
        apiHelper.getRecipe(userIngredients: []) { (apiResult, errorNetwork) in
            XCTAssertNotNil(apiResult)
            XCTAssertEqual(errorNetwork, ErrorNetwork.noRecipeFound)
        }
    }
    
    func testGetRecipesShouldPostFailedCallbackIfResponseIsNotCorrect() {
        let apiHelper = createAPIHelper(data: fakeResponseData.jsonOK, response: fakeResponseData.responseNotOK, error: fakeResponseData.error)
        
        apiHelper.getRecipe(userIngredients: []) { (apiResult, errorNetwork) in
            XCTAssertNil(apiResult)
            XCTAssertEqual(errorNetwork, ErrorNetwork.requestHasFailed)
        }
    }

}
