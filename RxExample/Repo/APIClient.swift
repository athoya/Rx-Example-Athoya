//
//  APIClient.swift
//  RxExample
//
//  Created by Jazilul Athoya on 25/01/19.
//  Copyright © 2019 Jazilul Athoya. All rights reserved.
//

import Foundation
import RxSwift

enum Method: String {
    case GET = "GET"
    case POST = "POST"
}

enum CustomHttpError: Error {
    case BadStatus(status: Int)
    case BadJsonBody
}

final class APIClient {
    private let baseURL: URL
    private let session: URLSession
    
    init(baseURL: URL, configuration: URLSessionConfiguration = URLSessionConfiguration.default) {
        self.baseURL = baseURL
        self.session = URLSession(configuration: configuration)
    }
    
    func send<T: BaseResponse>(apiRequest: URLRequest) -> Observable<T> {
        return Observable<T>.create { observer in
            let task = URLSession.shared.dataTask(with: apiRequest) { (data, response, error) in
                if let err = error {
                    observer.onError(err)
                } else {
                    let model: T = T(data: data ?? Data())
                    observer.onNext(model)
                }
                
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func request(path: String, method: Method, parameters: [String: String]) -> URLRequest {
        guard var components = URLComponents(url: URL(string: "\(baseURL)\(path)")!, resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }
        
        if parameters.count > 0 {
            components.queryItems = parameters.map {
                URLQueryItem(name: String($0), value: String($1))
            }
            
            print(components.url?.absoluteString)
        }
        
        guard let url = components.url else {
            fatalError("Could not get url")
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
