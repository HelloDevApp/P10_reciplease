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
    
    static var numberOfRecipe = 0
    
    static func createURL() -> URL {
        
        let apiKey = APIKey()
        let appID = apiKey.id
        let key = apiKey.key
       
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.edamam.com"
        components.path = "/search"
        components.queryItems =
            [URLQueryItem(name: "app_id", value: appID),
             URLQueryItem(name: "app_key", value: key),
             URLQueryItem(name: "q",        value: Data.userIngredients.joined(separator: ","))]
        let url = components.url
        return url!
    }
    
    static func getRecipe(callback: @escaping (APIResult?) -> Void) {
        
        let url = createURL()
        AF.request(url).responseJSON { (response) in
            guard let data = response.data, response.error == nil else {
                callback(nil)
                print("data or error, problem.")
                return
            }
            guard let json = try? JSONDecoder().decode(APIResult.self, from: data) else {
                callback(nil)
                print("json problem.")
                return
            }
            Data.hits = json.hits
            callback(json)
            return
        }
    }
    
    static func getImage(url: URL, callback: @escaping (UIImage?) -> Void) {
        AF.request(url).responseJSON { (data) in
            guard let data = data.data  else { return }
            guard let image = UIImage(data: data) else { return }
            Data.imageRecipe.append(image)
            callback(image)
        }
    }
}
