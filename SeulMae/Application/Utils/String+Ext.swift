//
//  String+Ext.swift
//  SeulMae
//
//  Created by 조기열 on 10/4/24.
//

import Foundation

extension String {
    var trimWhitespace: String {
        trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    var escapedURL: String {
        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}
