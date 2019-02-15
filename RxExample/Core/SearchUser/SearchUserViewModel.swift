//
//  SearchUserViewModel.swift
//  RxExample
//
//  Created by Jazilul Athoya on 14/02/19.
//  Copyright © 2019 Jazilul Athoya. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchUserViewModel: BaseViewModel {
    
    let bag = DisposeBag()
    
    var result = BehaviorRelay<[String: [GitRepository]]>(value: [:])
    var searchText = BehaviorRelay<String>(value: "")
    
    var isSuccess = BehaviorRelay<Bool>(value: false)
    var isLoading = BehaviorRelay<Bool>(value: false)
    var errorMessage = BehaviorRelay<String>(value: "")
    
    var repo = APIRepository()
    
    func searchUser(name: String) {
        var res = self.result.value
        res.removeAll()
        self.result.accept(res)
        
        self.repo.getUsers(name)
            .flatMap{ Observable.from($0.users) }
            .flatMap{ Observable.zip( Observable.just($0), self.repo.getUsersRepository(login: $0.name) ) }
            .subscribe{ (e) in
                if let user = e.element?.0, let value = e.element?.1 {
                    var res = self.result.value
                    res[user.name] = value.repos
                    self.result.accept(res)
                }
            }.disposed(by: bag)
    }
}
