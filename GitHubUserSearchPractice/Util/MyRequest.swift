//
//  MyRequest.swift
//  GitHubUserSearchPractice
//
//  Created by billHsiao on 2021/6/10.
//

import Foundation

enum Error: Swift.Error {
    case unknown(message: String?)
    case urlSessionError(Swift.Error)
    case httpResponseError(statusCode: Int, reason: String?, description: String?)
    case dataError
    case decodingError(Swift.Error)
}

class MyRequest {
    
    static var session: URLSession?
    
    enum HttpMethod : String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    static func sendRequest(urlString: String, method: HttpMethod, queryStrings: [String : String]?, jsonBody: Encodable?, result: @escaping (Result<Data, Error>) -> () ){
        
        let request = makeRequest(url: urlString, method: method, queryStrings: queryStrings, jsonBody: jsonBody)
        
        if session == nil {
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = 30.0
            sessionConfig.timeoutIntervalForResource = 30.0
            session = URLSession(configuration: sessionConfig)
        }
        
        print("-Send Request: [\(method)] \(urlString)")
        if method == .get{
            print("Parameter:", queryStrings ?? "nil")
        }
        else{
            print("Parameter:", jsonBody ?? "nil")
        }
        
        let dataTask = session!.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if let gotError = error {
            
            print(gotError)
            
            result(.failure(Error.urlSessionError(gotError)))
            
            
          } else {
            let httpResponse = response as? HTTPURLResponse
            
            print(httpResponse)
            
            switch httpResponse!.statusCode {
            case 204:
                // error
                result(.failure(Error.httpResponseError(statusCode: 204, reason: "204 error", description: "")))
            case 200...299:
                // retrive data
                
                if let data = data {
                    
                    result(.success(data))
                    
                } else {
                    
                    print("dataError")
                    result(.failure(Error.dataError))
                    
                }
            
            case 400...:
                // server error
                result(.failure(Error.httpResponseError(statusCode: 400, reason: "4xx error", description: "please try search again")))
           
            default:
                result(.failure(Error.unknown(message: "default error")))
            }
            
          }

            
        })

        dataTask.resume()
        
    }
    
    fileprivate static func makeRequest(url: String, method: HttpMethod, queryStrings: [String : String]?, jsonBody: Encodable?) -> URLRequest {
        
        var urlString = url
        
        if let queryStrings = queryStrings {
            let fullStr = "?" + generateFullQueryStrings(queryStrings: queryStrings)
            urlString += fullStr
        }
        
        let url = URL(string: urlString)
        
        var request = URLRequest(url: url!)
        
        switch method {
        case .get:
            request.httpMethod = "GET"
        case .post:
            request.httpMethod = "POST"
        case .put:
            request.httpMethod = "PUT"
        case .delete:
            request.httpMethod = "DELETE"
        }
                
        if let body = generateFullJsonBody(jsonBody: jsonBody) {
            request.httpBody = body
        }
        
        return request
    }
    
    fileprivate static func generateFullQueryStrings(queryStrings: [String : String]) -> String {
        
        let result = queryStrings.map { "\($0.0)=" + "\($0.1)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! }.joined(separator: "&")
        return result
        
    }
    
    fileprivate static func generateFullJsonBody(jsonBody: Encodable?) -> Data? {
        
        guard jsonBody != nil else {
            return nil
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody!)
        
        return jsonData
    }
    
    
}
