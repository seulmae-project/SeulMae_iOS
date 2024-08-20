//
//  WorkplaceStorage.swift
//  SeulMae
//
//  Created by 조기열 on 8/19/24.
//

import Foundation

protocol WorkplaceStorage {
    func fetchWorkplaces(account: String) -> Array<[String: Any]>
    func saveWorkplaces(workplaces: [Workplace], withAccount account: String) -> Bool
}
