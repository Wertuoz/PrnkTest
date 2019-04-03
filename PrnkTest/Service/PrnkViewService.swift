//
//  PrnkViewService.swift
//  PrnkTest
//
//  Created by Anton Trofimenko on 01/04/2019.
//  Copyright © 2019 Anton Trofimenko. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}
enum RequestError: Error {
    case unknownError
    case connectionError
    case invalidRequest
    case notFound
    case invalidResponse
    case serverError
    case serverUnavailable
    case authError
}

/// Service to call api methods
class PrnkViewService {
    
    private let baseUrl = "https://prnk.blob.core.windows.net/tmp/JSONSample.json"
    
    /// Call remote api for data
    func fetchData(callback: @escaping (ViewListData?, Error?) -> Void) {
        
        let url = URL(string: baseUrl)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print(error)
                callback(nil, error)
            } else if let data = data, let responseCode = response as? HTTPURLResponse {
                switch responseCode.statusCode {
                case 200:
                    let myResponse = try! JSONDecoder().decode(ViewListData.self, from: data)
                    callback(myResponse, nil)
                case 400...499:
                    callback(nil, RequestError.authError)
                case 500...500:
                    callback(nil, RequestError.serverError)
                default:
                    callback(nil, RequestError.unknownError)
                }
            } else {
                callback(nil, RequestError.unknownError)
            }
        }.resume()
    }
}
