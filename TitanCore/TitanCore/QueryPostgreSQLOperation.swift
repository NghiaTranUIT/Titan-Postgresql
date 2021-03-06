//
//  QueryPostgreSQLOperation.swift
//  TitanCore
//
//  Created by Nghia Tran on 4/24/17.
//  Copyright © 2017 nghiatran. All rights reserved.
//

import Foundation
import SwiftyPostgreSQL

class QueryPostgreSQLOperation: BaseOperation<QueryResult> {
    
    //
    // MARK: - Variable
    fileprivate var connect: Connection!
    fileprivate var rawQuery: Query!
    
    //
    // MARK: - Initializer
    convenience init(connect: Connection, rawQuery: Query) {
        self.init()
        self.connect = connect
        self.rawQuery = rawQuery
    }
    
    override func main() {
        super.main()
        
        // Cancel if need
        if self.checkCancelOperation() {
            return
        }
        
        // Exec
        Logger.info("[QUERY] = \(self.rawQuery)")
        let result = self.connect.execute(query: self.rawQuery)
        self.handleSuccess(result)
    }
    
}
