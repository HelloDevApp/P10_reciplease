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
    
    func createURL(userIngredients: [String]) -> URL {
        
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
        let url = components.url
        return url!
    }
    
    func getRecipe(userIngredients: [String], callback: @escaping (APIResult?) -> Void) {
        
        let url = createURL(userIngredients: userIngredients)
        print(url)
        
        // here that I would like to place my cancel
        AF.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let success):
                
                guard let json = try? JSONDecoder().decode(APIResult.self, from: response.data ?? Data()) else {
                    callback(nil)
                    print("json problem.")
                    return
                }
                callback(json)
            case .failure:
                callback(nil)
            }
        }
    }
    
    func getImage(url: URL, callback: @escaping (UIImage?) -> Void) {
        AF.request(url).responseJSON { (data) in
            guard let data = data.data  else { return }
            guard let image = UIImage(data: data) else { return }
            callback(image)
        }
    }
}
