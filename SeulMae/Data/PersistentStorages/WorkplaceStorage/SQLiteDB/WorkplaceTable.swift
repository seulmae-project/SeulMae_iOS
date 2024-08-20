//
//  WorkplaceTable.swift
//  SeulMae
//
//  Created by 조기열 on 8/5/24.
//

import Foundation

public class WorkplaceTable: SQLiteTable {
    override public func create(sql: String?) -> Bool {
        return super.create(sql: """
        CREATE TABLE IF NOT EXISTS workplace(
        id INTEGER PRIMARY KEY,
        account TEXT,
        name TEXT,
        user_workplace_id INTEGER,
        is_manager INTEGER
        );
        """)
    }
    
    // CREATE TABLE IF NOT EXISTS token
    // id INTEGER PRIMARY AUTO INCREMENT PRIMARY KEY,
    // user_id: INTEGER,
    // access_token: TEXT,
    // refresh_token: TEXT
    
    func save(
        workplaces: [Workplace],
        withAccount account: String
    ) -> Bool {
        var sql = "INSERT INTO workplace (id, name, account, user_workplace_id, is_manager) VALUES"
        let valueStrings = workplaces.map { "(\($0.id), '\($0.name)', '\(account)', \($0.userWorkplaceId), \($0.isManager))" }
        sql += valueStrings.joined(separator: ", ")
        return WorkplaceTable().save(sql: sql)
    }
    
    func fetch(account: String) -> Array<[String: Any]> {
        let sql = "SELECT * FROM workplace WHERE account = '\(account)';"
        let result: Array<[String: Any]> = WorkplaceTable().fetch(sql: sql)
        return result
    }
}
