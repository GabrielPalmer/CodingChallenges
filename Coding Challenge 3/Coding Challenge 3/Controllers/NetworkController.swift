//
//  NetworkController.swift
//  Coding Challenge 3
//
//  Created by Gabriel Blaine Palmer on 5/20/19.
//  Copyright © 2019 Gabriel Blaine Palmer. All rights reserved.
//

import Foundation
import UIKit

class NetworkController {
    static func fetchData(from url: URL, completion: @escaping (Data?) -> Void) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("There was a problem fetching data")
                print(error as Any)
            }
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            
            completion(data)
            
            
            }.resume()
    }
}

//===========================================
// MARK: - URL Extension
//===========================================

extension URL {
    func withQueries(_ queries: [String : String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.compactMap {
            URLQueryItem(name: $0.0, value: $0.1)}
        return components?.url
    }
}
