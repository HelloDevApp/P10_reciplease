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
    
    func getRecipe(userIngredients: [String], callback: @escaping (APIResult?, Int?) -> Void) {
        
        let url = createURL(userIngredients: userIngredients)
        print(url)
        let request = AF.request(url).responseJSON { (response) in
            
            switch response.result {
                
            case .success(let value):
                guard let json = try? JSONDecoder().decode(APIResult.self, from: response.data ?? Data()) else {
                    callback(nil, response.response?.statusCode)
                    return
                }
                
                if response.response?.statusCode == 200 && json.hits.isEmpty {
                    callback(nil, response.response?.statusCode)
                    return
                }
                callback(json, nil)
                
            case .failure:
                guard let response = response.response else { return }
                switch response.statusCode {
                case 400...499:
                    callback(nil, response.statusCode)
                default:
                    callback(nil, response.statusCode)
                }
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
