//
//  GetUserResponse.swift
//  RxExample
//
//  Created by Jazilul Athoya on 14/02/19.
//  Copyright © 2019 Jazilul Athoya. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetUserResponse : BaseResponse {
    var users: [User] = []
    
    required init(data: Data) {
        super.init(data: data)
        if let json = try? JSON(data: data) {
            let items = json["items"].arrayValue
            items.forEach({ (da) in
                let d = User()
                d.name = da["login"].stringValue
                users.append(d)
            })
        }
    }
}
