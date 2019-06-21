//
//  APIHelper.swift
//  P10_Reciplease
//
//  Created by macbook pro on 08/06/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import Foundation
import Alamofire

class APIHelper {
    
    var from = 1
    var to = 10
    
    func createURL(userIngredients: [String]) -> URL? {
        
        let apiKey = APIKey()
       
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.edamam.com"
        components.path = "/search"
        components.queryItems =
            [URLQueryItem(name: "app_id", value: apiKey.id),
             URLQueryItem(name: "app_key", value: apiKey.key),
             URLQueryItem(name: "q", value: userIngredients.joined(separator: ",")),
             URLQueryItem(name: "from", value: String(from)),
             URLQueryItem(name: "to", value: String(to))]
        
        guard let url = components.url else { return nil }
        return url
    }
    
    func getRecipe(userIngredients: [String], callback: @escaping (APIResult?, Int?) -> Void) {
        
        guard let url = createURL(userIngredients: userIngredients) else { return }
        AF.request(url).responseJSON { (response) in
            print(url)
            switch response.result {
            case .success(_):
                print("success")
                guard let json = try? JSONDecoder().decode(APIResult.self, from: response.data ?? Data()) else {
                    print("success json failed")
                    callback(nil, response.response?.statusCode)
                    return
                }
                print("success json in callback")
                callback(json, nil)
                
            case .failure:
                print("failure")
                guard let response = response.response else { return }
                callback(nil, response.statusCode)
            }
        }
    }
}
