//
//  SQLiteWorkplaceStorage.swift
//  SeulMae
//
//  Created by 조기열 on 8/19/24.
//

import Foundation

final class SQLiteWorkplaceStorage {
    
    private let table: WorkplaceTable
    
    init(table: WorkplaceTable = WorkplaceTable()) {
        self.table = table
    }
}

extension SQLiteWorkplaceStorage: WorkplaceStorage {
    func saveWorkplaces(workplaces: [Workplace], withAccount account: String) -> Bool {
        table.save(workplaces: workplaces, withAccount: account)
    }
    
    func fetchWorkplaces(account: String) -> Array<[String: Any]> {
        let workplaces = table.fetch(account: account)
        Swift.print(#line, "account: \(account)")
        Swift.print(#line, "workplace count: \(workplaces.count)")
        return workplaces
    }
}
