//
//  Data+String.swift
//  SeulMae
//
//  Created by 조기열 on 8/16/24.
//

import Foundation
extension Data {
    func prettyString() throws -> String {
        do {
        let json = try JSONSerialization.jsonObject(with: self, options: .mutableContainers)
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            return String(decoding: jsonData, as: UTF8.self)
        } catch let error {
            throw error
        }
    }
}
