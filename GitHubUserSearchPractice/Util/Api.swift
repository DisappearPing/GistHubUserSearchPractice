//
//  Api.swift
//  GitHubUserSearchPractice
//
//  Created by billHsiao on 2021/6/9.
//

import Foundation

protocol Api {
    func getUserListWithUserName(_ searchedName: String, page: Int, result: @escaping (Result<SearchResultResponseObject, Error>) -> ())
}

class MyApiService: Api {
    
    private init() {}
    
    static let shared = MyApiService()
    
    func getUserListWithUserName(_ searchedName: String, page: Int, result: @escaping (Result<SearchResultResponseObject, Error>) -> ()) {
        
//        https://api.github.com/search/users?q=bill&per_page=10&page=1
        MyRequest.sendRequest(urlString: "https://api.github.com/search/users", method: .get, queryStrings: ["q" : searchedName, "page" : "\(page)", "per_page" : "10"] , jsonBody: nil) { requestResult in
            
            DispatchQueue.main.async {
                            
            switch requestResult {
            
            case .success(let data):
                
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data) as! [String: Any]
                    
                    let jsonObjectFromDecoder = try JSONDecoder().decode(SearchResultResponseObject.self, from: data)
                    
                    print("jsonObjectFromDecoder = \(jsonObjectFromDecoder)")
                    
                    print("jsonObject = \(jsonObject)")
                    
                    result(.success(jsonObjectFromDecoder))
                    
                } catch let error {
                    print("error = \(error.localizedDescription)")
                    result(.failure(Error.decodingError(error)))
                }
                
            case .failure(let error):
            
                result(.failure(error))
                
            }
            
            }

        }
        
        
    }

}
