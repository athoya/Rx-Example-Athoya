//
//  ViewController.swift
//  RxExample
//
//  Created by Jazilul Athoya on 25/01/19.
//  Copyright © 2019 Jazilul Athoya. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

class SearchUserViewController: UIViewController {
    
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var userSearchBar: UISearchBar!
    
    var bag = DisposeBag()
    
    var viewModel = SearchUserViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bag = DisposeBag()
        
//        userSearchBar.delegate = self
        viewModelBinding()
    }
    
    func viewModelBinding() {
        
        self.viewModel.result.bind(to: userTableView.rx.items(cellIdentifier: "UserCell")) { index, model, cell in
            cell.textLabel?.text = model.key
            cell.detailTextLabel?.text = "\(model.value.count)"
            print(model.key)
            print(model.value.count)
            
            }.disposed(by: bag)
        
        self.userSearchBar.rx.value.asObservable()
            .debounce(2, scheduler: MainScheduler.instance)
            .subscribe { (e) in
                if let s = e.element.unsafelyUnwrapped {
                    if !s.isEmpty {
                        self.viewModel.searchUser(name: s)
                    }
                }
        }.disposed(by: bag)
        
        self.userTableView.rx.itemSelected.subscribe{ indexPath in
            print(indexPath.element)
            }.disposed(by: bag)
        
        viewModel.isLoading.asObservable().subscribe { (e) in
            print(e.element)
        }
    }

}

//extension SearchUserViewController : UISearchBarDelegate, UISearchDisplayDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print(searchText)
////        self.searchText.accept(searchText)
//        self.viewModel.searchText.accept(searchText)
//    }
//}


//        repo.getUsers()
//            .flatMap { Observable.from($0.users) }
//            .flatMap{ Observable.zip( Observable.just($0), self.repo.getUsersRepository(login: $0.name) ) }
//            .subscribe{ (e) in
//                if let user = e.element?.0, let value = e.element?.1 {
//                    var res = self.result.value
//                    res[user.name] = value.repos
//                    self.result.accept(res)
//                }
//            }.disposed(by: bag)


//        self.result.asObservable().bind(to: userTableView.rx.items) { tableView, index, element in
//            let indexPath = IndexPath(row: index, section: 0)
//            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
//            cell.textLabel?.text = element.key
//            cell.detailTextLabel?.text = "\(element.value.count) repos"
//            return cell
//        }.disposed(by: bag)



//        repo.getUsers().subscribe { (event) in
//            event.element?.users.forEach{
//                let name = $0.name
//
//                self.repo.getUsersRepository(login: name).subscribe({ (e) in
//                    if let value = e.element?.repos {
//                        var res = self.result.value
//                        res[name] = value
//                        self.result.accept(res)
//                    }
//
//                }).disposed(by: self.bag)
//
//            }
//        }.disposed(by: bag)

//        repo.getUsers()
//            .flatMap { Observable.from($0.users) }
//            .flatMap{ self.repo.getUsersRepository(login: $0.name) }
//            .subscribe{ (e) in
////                if let value = e.element?.repos {
////                    var res = self.result.value
////                    res[name] = value
////                    self.result.accept(res)
////                }
//                print(e.element?.repos.count)
//        }.disposed(by: bag)



//        userSearchBar.delegate = self
//        userSearchBar.rx.text.asDriver().subscribe { e in
//            print(e.element)
//        }.disposed(by: bag)


//
//        bindTo(choiceTableView.rx_itemsWithCellIdentifier("ChoiceCell", cellType: ChoiceCell.self)) { (row, element, cell) in
//            cell.choiceModel = element
//
