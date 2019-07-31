//
//  APIHelper.swift
//  P10_Reciplease
//
//  Created by macbook pro on 08/06/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import Alamofire

class APIHelper {
    
    // MARK: - Properties
    var from = 0
    var to = 19
    var session: APISessionProtocol?
    
    // MARK: - Init
    init(session: APISessionProtocol = APISession()) {
        self.session = session
    }
    
    // MARK: - Methods
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
    
    func getRecipe(userIngredients: [String], callback: @escaping (APIResult?, ErrorNetwork) -> Void) {

        guard let url = createURL(userIngredients: userIngredients) else { return }
        session?.request(url: url) { (response) in
            print(url)
            
            guard let data = response.data else {
                callback(nil, .requestHasFailed)
                return
            }
            
            switch response.result {
            case .success(_):
                print("success")
                guard let json = try? JSONDecoder().decode(APIResult.self, from: data) else {
                    print("decode json failed")
                    callback(nil, .wrongJSON)
                    return
                }
                guard !json.hits.isEmpty else {
                    callback(json, .noRecipeFound)
                    return
                }
                print("success json in callback")
                callback(json, .noError)
                
            case .failure:
                print("failure")
                callback(nil, .requestHasFailed)
            }
        }
    }
}
