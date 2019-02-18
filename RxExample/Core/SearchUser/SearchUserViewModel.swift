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
        
        isLoading.accept(false)
        
        self.repo.getUsersWithAlmo(name)
            .flatMap{ Observable.from($0.users) }
            .flatMap{ Observable.zip( Observable.just($0), self.repo.getUsersRepository(login: $0.name) ) }.subscribe(onNext: { (arg0) in
                let (user, repo) = arg0
                var res = self.result.value
                res[user.name] = repo.repos
                self.result.accept(res)
            }, onError: { (error) in
                print(error.localizedDescription)
            }, onCompleted: {
                self.isLoading.accept(true)
                print("completed")
            }) { // ondisposed
                print("OnDisposed")
        }.disposed(by: bag)
    }
}
