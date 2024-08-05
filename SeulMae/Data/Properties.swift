//
//  Properties.swift
//  SeulMae
//
//  Created by 조기열 on 8/5/24.
//

import Foundation

public class WorkplaceTable: Table {
    override public func onCreate(sql:String?) -> Bool {
        return super.onCreate(sql: """
        CREATE TABLE IF NOT EXISTS workplace(
        id INTEGER PRIMARY KEY,
        place_name TEXT,
        value TEXT
        );
        """)
    }
    
    @discardableResult static func set(key:String, value:String)->Bool{
        let sql = String(format: "INSERT INTO TBL_DEFAULT_PROPERTIES (key, value) VALUES (\"%@\", \"%@\")", key, value)
        return WorkplaceTable().set(sql: sql)
    }
    
    static func get(
        workplaceIdentifier id: Int,
        defaultValue: String = ""
    ) -> [Workplace] {
        let sql = String(format: "SELECT value FROM workpkace WHERE id='%@'", id)
        let result: Array<[String: String]> = WorkplaceTable().get(sql: sql)
        guard let json = try? JSONSerialization.data(withJSONObject: result, options: []),
              let data = try? JSONDecoder().decode([WorkplaceDTO].self, from: json) else {
            return []
        }
        let entities = data.compactMap { try? $0.toDomain() }
        return entities
    }
}
