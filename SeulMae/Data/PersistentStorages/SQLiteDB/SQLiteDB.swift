//
//  SQLiteStorage.swift
//  SeulMae
//
//  Created by 조기열 on 8/5/24.
//

import Foundation
import SQLite3

open class SQLiteDB {
    static let shared: SQLiteDB = {
        let instance = SQLiteDB()
        return instance
    }()
    
    private var db: OpaquePointer?
    private var tables: [String: SQLiteTable] = [:]
    
    public init() {}
    deinit {}
    
    @discardableResult
    public func initialize(databaseName: String) -> Bool {
        return SQLiteDB.shared.open(databaseName: databaseName)
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
    
    public func destroy() { SQLiteDB.shared.close() }
    
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
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                retval = true
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("SQLite error: \(errorMessage)")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("SQLite prepare error: \(errorMessage)")
        }
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
    
    public func select(sql: String) -> Array<[String: Any]> {
        var retval: Array<[String: Any]> = []
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            let column: Int32 = sqlite3_column_count(statement)
            while sqlite3_step(statement) == SQLITE_ROW {
                var dic: [String: Any] = [:]
                for i in 0...(column - 1) {
                    let key = String(cString: sqlite3_column_name(statement, i)!)
                    let columnType = sqlite3_column_type(statement, i)
                    switch columnType {
                    case SQLITE_INTEGER:
                        let isBooleanColumn = key.hasPrefix("is")
                        let value = Int(sqlite3_column_int(statement, i))
                        dic[key] = isBooleanColumn ? (value != 0) : value
                    case SQLITE_FLOAT:
                        dic[key] = Double(sqlite3_column_double(statement, i))
                    case SQLITE_TEXT:
                        dic[key] = String(cString: sqlite3_column_text(statement, i)!)
                    case SQLITE_BLOB:
                        let data = sqlite3_column_blob(statement, i)
                        let dataSize = sqlite3_column_bytes(statement, i)
                        if let data = data {
                            dic[key] = Data(bytes: data, count: Int(dataSize))
                        }
                    case SQLITE_NULL:
                        dic[key] = nil
                    default:
                        Swift.print("Unknown column type")
                    }
                }
                retval.append(dic)
            }
        }
        sqlite3_finalize(statement)
        return retval
    }
    
    public static func key(table: SQLiteTable) -> String {
        let key = String(describing: table.self)
        let initialLowercased = key.prefix(1).lowercased() + key.dropFirst()
        let snakeCase = initialLowercased.reduce(into: "") { result, char in
            result += (char.isUppercase ? ("_" + char.lowercased()) : String(char))
        }
        Swift.print("snakeCase: \(snakeCase)")
        return snakeCase
    }
    
    public func register(table: SQLiteTable) -> Bool {
        let key = SQLiteDB.key(table: table)
        if SQLiteDB.shared.tables[key] == nil {
            tables[key] = table
            return true
        }
        return false
    }

    public func check(table: SQLiteTable) -> Bool {
        let key = SQLiteDB.key(table: table)
        return SQLiteDB.shared.tables[key] != nil
    }
    
    public func count(table: SQLiteTable) -> Int32 {
        Swift.print("table: \(SQLiteDB.key(table: table))")
        let sql = String(format:"SELECT COUNT(*) FROM %@", "workplace")
        let result: String? = select(sql: sql)
        return Int32((result ?? "0"))!
    }
    
    public func clear(table: SQLiteTable) -> Bool {
        let sql = String(format:"DELETE FROM %@", SQLiteDB.key(table: table))
        return execute(sql: sql)
    }
}
