//
//  DatabaseRealmObj.swift
//  Titan
//
//  Created by Nghia Tran on 11/6/16.
//  Copyright © 2016 fe. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseRealmObj: Object {
    
    //
    // MARK: - Variable
    dynamic var name: String!
    dynamic var host: String!
    dynamic var username: String!
    dynamic var user: UserRealmObj!
    dynamic var password: String!
    dynamic var database: String!
    dynamic var port: Int = 5432
    dynamic var saveToKeychain = false
    dynamic var ssl: SSLRealmObj?
    dynamic var ssh: SSHRealmObj?
    
    //
    // MARK: - Public
    func convertToModelObj() -> DatabaseObj {
        return DatabaseObj()
    }
}


//
// MARK: - Base Realm model protocol
extension DatabaseRealmObj: BaseRealmModel { }


//
// MARK: - Object Model Convertible
extension DatabaseRealmObj: ObjectModelConvertible {
    
    typealias E = DatabaseObj

    func toObjectModel() -> E {
        let db = E()
        
        db.name = self.name
        db.host = self.host
        db.password = self.password
        db.port = self.port
        
        return db
    }
}