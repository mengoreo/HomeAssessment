//
//  TokenFetcher.swift
//  HomeAssessment
//
//  Created by Mengoreo on 2020/2/9.
//  Copyright © 2020 Mengoreo. All rights reserved.
//

import Foundation

struct DjangoAPI {
//  static let scheme = "http"
//  static let host = "localhost:8000"
//  static let path = "/api/token_auth/"
    static let apiPath = "http://localhost:8000/api/token_auth/"
}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let tokenResponse = try? newJSONDecoder().decode(TokenResponse.self, from: jsonData)


// MARK: - Token
struct TokenResponse: Codable {
    let token: String
}

class TokenFetcher {
    var name: String
    var password: String

    var statusCode: Int = 400
    var token: String = ""
//    var token: String {
//        return fetchToken(name: name, password: password)
//    }
    
    init(name: String, password: String) {
        self.name = name
        self.password = password
    }
    
    func fetchToken(completionHandler: ((String, NSError?) -> Void)?) -> URLSessionDataTask {
        print("** TokenFetcher:", "name:\(name), password:\(password)")
        let url = URL(string: DjangoAPI.apiPath)!
        let postString = "username=\(name)&password=\(password)"
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        request.timeoutInterval = 20
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                completionHandler?("", error as NSError?)
                return
            }
            
            do {
                guard let response = response as? HTTPURLResponse else {
                    completionHandler?("", NSError(domain: "HA", code: 9090, userInfo: ["No Respose": 9090]))
                    return
                }
                
                guard let data = data else {
                    completionHandler?("", NSError(domain: "HA", code: 8080, userInfo: ["No Data": 8080]))                
                    return
                }
    
                if response.statusCode == 200 {
                    // ok
                    sleep(5)
                    let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                    completionHandler?(tokenResponse.token, nil)
                } else {
                    // not ok
                    completionHandler?("", NSError(domain: "HA", code: 7070, userInfo: ["Not Authorised": 7070]))
                }
            } catch {
                print("*** TokenFetcher:", error)
            }
        }
        task.resume()
        return task
    }
    
}
