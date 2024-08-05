//
//  Table.swift
//  SeulMae
//
//  Created by 조기열 on 8/5/24.
//

import Foundation

open class Table {
    public init() {  
        if DB.shared.register(table: self) {
            self.onCreate(sql: nil)
        }
    }
    
    deinit {}
    
    @discardableResult open func onCreate(sql: String?) -> Bool {
        return DB.shared.execute(sql: sql!)
    }
    
    public func get(sql:String) -> String? { return DB.shared.select(sql: sql) }
    public func get(sql:String) -> Array<Dictionary<String,String>> {
        return DB.shared.select(sql: sql)
    }
    
    @discardableResult public func set(sql:String) -> Bool {
        return DB.shared.execute(sql: sql)
    }
    
    public func count() -> Int32 {
        return DB.shared.count(table: self)
    }
    
    @discardableResult public func clear() -> Bool {
        return DB.shared.clear(table: self)
    }
}
