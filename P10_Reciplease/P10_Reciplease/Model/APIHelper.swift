//
//  APIHelper.swift
//  P10_Reciplease
//
//  Created by macbook pro on 08/06/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import Alamofire

class APIHelper {
    
    var from = 0
    var to = 19
    
    private func createURL(userIngredients: [String]) -> URL? {
        
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
        AF.request(url).responseJSON { [weak self] (response) in
            print(url)
            
            guard self != nil else { return }
            
            guard let responseStatusCode = response.response?.statusCode else {
                callback(nil, nil)
                return
            }
            
            guard let data = response.data else {
                callback(nil, responseStatusCode)
                return
            }
            
            switch response.result {
            case .success(_):
                print("success")
                guard let json = try? JSONDecoder().decode(APIResult.self, from: data) else {
                    print("decode json failed")
                    callback(nil, responseStatusCode)
                    return
                }
                print("success json in callback")
                callback(json, responseStatusCode)
                
            case .failure:
                print("failure")
                callback(nil, responseStatusCode)
            }
        }
    }
}
