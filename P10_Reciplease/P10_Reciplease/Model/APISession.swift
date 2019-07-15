//
//  FakeSession.swift
//  P10_RecipleaseTests
//
//  Created by macbook pro on 11/07/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import Foundation
import Alamofire

protocol APISessionProtocol {
    func request(url: URL, callback: @escaping (DataResponse<Any>) -> Void)
}

class APISession: APISessionProtocol {
    
    func request(url: URL, callback: @escaping (DataResponse<Any>) -> Void) {
        
        Alamofire.request(url).responseJSON { (dataResponse) in
            callback(dataResponse)
        }
    }

}
