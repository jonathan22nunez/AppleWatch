//
//  DBHelperProtocol.swift
//  NunezJonathan_WearableProject
//
//  Created by Jonathan Nunez on 6/24/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import Foundation

protocol DBHelperProtocol {
    
    static var tableName: String {get}
    
    static var childId: String {get}
    
    static var createTableString: String {get}
    
    static var insertIntoTableString: String {get}
    
    static var queryTableString: String {get}
}

extension DBHelperProtocol {
    static var childId: String {return "childId"}
}
