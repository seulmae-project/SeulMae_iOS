//
//  WorkplaceTable.swift
//  SeulMae
//
//  Created by 조기열 on 8/5/24.
//

import Foundation

public class WorkplaceTable: Table {
    override public func onCreate(sql: String?) -> Bool {
        return super.onCreate(sql: """
        CREATE TABLE IF NOT EXISTS workplace(
        id INTEGER PRIMARY KEY,
        place_name TEXT,
        userWorkplaceId INTEGER
        );
        """)
    }
    
    @discardableResult static func set(key: Int, placeName: String, userWorkplaceID: Int) -> Bool {
        let sql = """
            INSERT INTO workplace (id, place_name, userWorkplaceId)
            VALUES (\(key), "\(placeName)", \(userWorkplaceID))
        """
        return WorkplaceTable().set(sql: sql)
    }
    static func get2() -> Array<[String: Any]> {
        let sql = String(format: "SELECT * FROM workplace")
        let result: Array<[String: Any]> = WorkplaceTable().get(sql: sql)
        return result
    }
    
    static func get() -> [Workplace] {
        let sql = String(format: "SELECT * FROM workplace")
        let result: Array<[String: Any]> = WorkplaceTable().get(sql: sql)
        Swift.print(#line, "🥰 result: \(result)")
        guard let json = try? JSONSerialization.data(withJSONObject: result, options: []),
              let data = try? JSONDecoder().decode([WorkplaceDTO].self, from: json) else {
            return []
        }
        let entities = data.compactMap { try? $0.toDomain() }
        return entities
    }
}
