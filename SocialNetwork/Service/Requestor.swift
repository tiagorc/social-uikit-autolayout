//
//  Requestor.swift
//  SocialNetwork
//
//  Created by Euler Carvalho on 02/06/21.
//

import Foundation

typealias Completion = ((_ result: Any?, _ error: Error?) -> Void)

class Requestor {
    private let session = URLSession.shared
    
    func get<T: Decodable> (url: URL, `class`: T.Type, completion: @escaping Completion) {
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard self.isValid(response: response),
                  let dataValue = data,
                  let object = try? JSONDecoder().decode(`class`, from: dataValue) else {
                completion(nil, error)
                return
            }
            
            completion(object, nil)
        }
        task.resume()
    }
    
    func isValid(response: URLResponse?) -> Bool {
        guard let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            return false
        }
        return true
    }
}
