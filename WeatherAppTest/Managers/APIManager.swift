//
//  APIManager.swift
//  WeatherAppTest
//
//  Created by Shandor Baloh on 01.03.2023.
//

import Foundation

final class APIManager {
    
    static let shared = APIManager()
    
    enum HttpMethod: String {
        case get
        case post
        case put
        case patch
        case delete
    }
    
    private func parsResult<T: Decodable>(request: URLRequest, completion: @escaping (T?, Error?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: request) { (data, resp, error) in
                guard error == nil else {
                    completion(nil, error)
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(decodedResponse, nil)
                    }
                } catch let JsonError as NSError {
                    completion(nil, JsonError)
                }
            }.resume()
        }
    }
    
    func makeRequest<T: Decodable>(toURL url: String, withHttpMethod httpMethod: HttpMethod, queryParameters: [String : Any]? = [:], httpBody: [String : Any]? = [:], completion: @escaping (T?, Error?) -> Void) {
        let requestCompletion: (T?, Error?) -> Void = { (model, error) in
            completion(model, error)
        }
        
        var urlComponents = URLComponents(string: url)
        var queryItems: [URLQueryItem] = []
        for (key, value) in (queryParameters ?? [:]) {
            queryItems.append(URLQueryItem(name: key, value: "\(value)"))
        }
        urlComponents?.queryItems = queryItems
        guard let url = (urlComponents?.url) else { return }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: httpBody)
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        if !(httpBody?.isEmpty ?? true) {
            request.httpBody = jsonData
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        }
        
        parsResult(request: request, completion: requestCompletion)
    }
}
