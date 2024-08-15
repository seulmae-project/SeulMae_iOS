//
//  DB.swift
//  SeulMae
//
//  Created by 조기열 on 8/5/24.
//

import Foundation
import SQLite3

open class DB {
    static let shared: DB = {
        let instance = DB()
        return instance
    }()
    
    private var db: OpaquePointer?
    private var tables: [String: Table] = [:]
    
    public init() {}
    deinit {}
    
    public func initialize(databaseName: String) -> Bool {
        return DB.shared.open(databaseName: databaseName)
    }
    
    public func open(databaseName: String) -> Bool {
        do {
            let dbFile = try FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(databaseName)
            return (sqlite3_open(dbFile.path, &db) == SQLITE_OK)
        } catch {
            Swift.print("Couldn't open database:\n\(error.localizedDescription)")
            return false
        }
    }
    
    public func destroy() { DB.shared.close() }
    
    public func close() { sqlite3_close(db) }
        
//    public func execute(sql: String) -> Bool {
//        var retval: Bool = false
//        var statement: OpaquePointer? = nil
//        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
//            if sqlite3_step(statement) == SQLITE_DONE {
//                retval = true
//            }
//        }
//        sqlite3_finalize(statement)
//        return retval
//    }
    public func execute(sql: String) -> Bool {
        var retval: Bool = false
        var statement: OpaquePointer? = nil

        // Prepare the SQL statement
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            // Execute the SQL statement
            if sqlite3_step(statement) == SQLITE_DONE {
                retval = true
            } else {
                // Log error if step fails
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("SQLite error: \(errorMessage)")
            }
        } else {
            // Log error if prepare fails
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("SQLite prepare error: \(errorMessage)")
        }

        // Finalize the statement
        if statement != nil {
            sqlite3_finalize(statement)
        }

        return retval
    }
    
    public func select(sql: String) -> String? {
        var retval:String? = nil
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_ROW {
                let result = sqlite3_column_text(statement, 0)
                retval = String(cString: result!)
            }
        }
        sqlite3_finalize(statement)
        return retval
    }
    
    public func select(sql: String) -> Array<[String: String]> {
        var retval: Array<[String: String]> = []
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            let column: Int32 = sqlite3_column_count(statement)
            while sqlite3_step(statement) == SQLITE_ROW {
                var dic: [String : String] = [:]
                for i in 0...(column - 1) {
                    // TODO: - 여기서 타입별로 가저오도록 ..
                    let key = String(cString: sqlite3_column_name(statement, i)!)
                    let value = String(cString: sqlite3_column_text(statement, i)!)
                    dic[key]=value
                }
                retval.append(dic)
            }
        }
        sqlite3_finalize(statement)
        return retval
    }
    
    public static func key(table: Table) -> String {
        let thisType = type(of: table.self)
        let key = String(describing: thisType)
        return key
    }
    
    public func register(table: Table) -> Bool {
        let key = DB.key(table: table)
        if DB.shared.tables[key] == nil {
            tables[key] = table
            return true
        }
        return false
    }
    
    public func check(table: Table) -> Bool {
        let key = DB.key(table: table)
        return DB.shared.tables[key] != nil
    }
    
    public func count(table: Table) -> Int32 {
        Swift.print("table: \(DB.key(table: table))")
        let sql = String(format:"SELECT COUNT(*) FROM %@", "workplace")
        let result: String? = select(sql:sql)
        return Int32((result ?? "0"))!
    }
    
    public func clear(table: Table) -> Bool {
        let sql = String(format:"DELETE FROM %@", DB.key(table: table))
        return execute(sql: sql)
    }
}
