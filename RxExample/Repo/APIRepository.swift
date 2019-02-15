//
//  APIRepository.swift
//  RxExample
//
//  Created by Jazilul Athoya on 25/01/19.
//  Copyright © 2019 Jazilul Athoya. All rights reserved.
//

import Foundation
import RxSwift

final class APIRepository {
    
    let client = APIClient(baseURL: URL(string: "https://api.github.com")!)
    
    func getUsers(_ q: String) -> Observable<GetUserResponse> {
        let r = client.request(path: "/search/users", method: .GET, parameters: ["q":q])
        return client.send(apiRequest: r)
    }
    
    func getUsersRepository(login: String) -> Observable<GetGitRepository>{
        let r = client.request(path: "/users/\(login)/repos", method: .GET, parameters: [:])
        return client.send(apiRequest: r)
    }
}
