//
//  FakeAPISession.swift
//  P10_RecipleaseTests
//
//  Created by macbook pro on 11/07/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

@testable import P10_Reciplease
import Foundation
import Alamofire

class FakeAPISession: APISessionProtocol {
    
    private let fakeResponse: FakeResponse
    var dataResponse: DataResponse<Any>?
    
    init(fakeResponse: FakeResponse) {
        self.fakeResponse = fakeResponse
    }
    
    func request(url: URL, callback: @escaping (DataResponse<Any>) -> Void) {

        let urlRequest = URLRequest(url: url)
        
        let data = fakeResponse.data
        let response = fakeResponse.response
        let error = fakeResponse.error
        let result = Request.serializeResponseJSON(options: .allowFragments, response: response, data: data, error: error)
        
        dataResponse = DataResponse(request: urlRequest, response: response, data: data, result: result)
        
        callback(DataResponse(request: urlRequest, response: response, data: data, result: result))
        
    }
}
