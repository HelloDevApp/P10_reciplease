//
//  FakeData.swift
//  P10_RecipleaseTests
//
//  Created by macbook pro on 11/07/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//
import UIKit
import Foundation

class ErrorProtocol: Error {}

class FakeResponseData {
    
    let userIngredients = ["test", "test"]
    let incorrectData = "error".data(using: .utf8)
    let image = "image".data(using: .utf8)
    let error = ErrorProtocol()
    
    
    
    
    var jsonOK: Data {
        let data = recoverUrlJSONFiles(nameJson: "JSON_OK")
        return data
    }
    
    var incorrectJSON: Data {
        let data = recoverUrlJSONFiles(nameJson: "IncorrectJSON")
        return data
    }
    
    var jsonWithEmpyRecipes: Data {
        let data = recoverUrlJSONFiles(nameJson: "JSON_WithEmptyRecipes")
        return data
    }
    
    // HTTPURLResponse
    let responseOK = HTTPURLResponse(url: URL(string: "www.test.com")!, statusCode: 200, httpVersion: nil, headerFields: [:])
    let responseNotOK =  HTTPURLResponse(url: URL(string: "www.test.com")!, statusCode: 500, httpVersion: nil, headerFields: [:])
    let responseNotOK2 =  HTTPURLResponse(url: URL(string: "www.test.com")!, statusCode: 400, httpVersion: nil, headerFields: [:])
    let responseNotTypeHTTPURLResponse = URLResponse(url: URL(string: "www.testURL.com")!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)

    func recoverUrlJSONFiles(nameJson: String) -> Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: nameJson, withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    func recoverUrlXMLFiles(nameJson: String) -> Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: nameJson, withExtension: "xml")
        let data = try! Data(contentsOf: url!)
        return data
    }
}
