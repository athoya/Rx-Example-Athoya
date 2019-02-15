//
//  BaseModel.swift
//  RxExample
//
//  Created by Jazilul Athoya on 28/01/19.
//  Copyright © 2019 Jazilul Athoya. All rights reserved.
//

import Foundation

class BaseResponse {
    
    var url: URLRequest?
    var data: Data?
    
    init(){
        
    }
    
    required init(data: Data) {
        self.data = data
    }
}

