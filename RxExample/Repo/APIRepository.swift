//
//  APIRepository.swift
//  RxExample
//
//  Created by Jazilul Athoya on 25/01/19.
//  Copyright © 2019 Jazilul Athoya. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

final class APIRepository {
    
    let baseUrl = "https://api.github.com"
    let client = APIClient(baseURL: URL(string: "https://api.github.com")!)
    
    func getUsers(_ q: String) -> Observable<GetUserResponse> {
        let r = client.request(path: "/search/users", method: .GET, parameters: ["q":q])
        return client.send(apiRequest: r)
    }
    
    func getUsersRepository(login: String) -> Observable<GetGitRepository>{
        let r = client.request(path: "/users/\(login)/repos", method: .GET, parameters: [:])
        return client.send(apiRequest: r)
    }
    
    func getUsersWithAlmo(_ q: String) -> Observable<GetUserResponse> {
        let manager = SessionManager.default
        let param : Parameters = ["q":q]
//        let header = ["accept" : "application/json"]
        let header : [String: String] = [:]
        
//        return manager.rx.data(.get, "\(baseUrl)/search/users/q?=\(q)", parameters: param, encoding: URLEncoding.httpBody, headers: header)
//            .flatMap{ Observable.just(GetUserResponse.init(data: $0)) }
        return manager.rx.data(.get, "\(baseUrl)/search/users?q=\(q)").flatMap{ Observable.just(GetUserResponse.init(data: $0)) }
        
//        return manager.rx.data(.get, baseUrl)
//            .observeOn(MainScheduler.instance).flatMap { (data) -> Observable<GetUserResponse> in
//                return Observable.just(GetUserResponse.init(data: data))
//        }
    }
}
