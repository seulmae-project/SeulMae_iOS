//
//  SQLiteTable.swift
//  SeulMae
//
//  Created by 조기열 on 8/5/24.
//

import Foundation

open class SQLiteTable {
    public init() {  
        if SQLiteDB.shared.register(table: self) {
            self.create(sql: nil)
        }
    }
    
    deinit {}
    
    @discardableResult open func create(sql: String?) -> Bool {
        let isCreated = SQLiteDB.shared.execute(sql: sql!)
        return isCreated
    }
    
    public func fetch(sql: String) -> Array<[String: Any]> {
        return SQLiteDB.shared.select(sql: sql)
    }
    
    @discardableResult public func save(sql:String) -> Bool {
        return SQLiteDB.shared.execute(sql: sql)
    }
    
    public func count() -> Int32 {
        return SQLiteDB.shared.count(table: self)
    }
    
    @discardableResult public func clear() -> Bool {
        return SQLiteDB.shared.clear(table: self)
    }
}
