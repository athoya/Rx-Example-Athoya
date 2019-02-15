//
//  GetUserRepository.swift
//  RxExample
//
//  Created by Jazilul Athoya on 14/02/19.
//  Copyright © 2019 Jazilul Athoya. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetGitRepository : BaseResponse {
    var repos: [GitRepository] = []
    
    required init(data: Data) {
        super.init(data: data)
        if let json = try? JSON(data: data) {
            let items = json.arrayValue
            items.forEach({ (da) in
                let d = GitRepository()
                d.name = da["full_name"].stringValue
                repos.append(d)
            })
        }
    }
}
