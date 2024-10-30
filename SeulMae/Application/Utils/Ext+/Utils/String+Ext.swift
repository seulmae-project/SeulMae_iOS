//
//  String+Ext.swift
//  SeulMae
//
//  Created by 조기열 on 10/30/24.
//

import Foundation
import RxSwift
import RxCocoa

extension Ext where ExtendedType == String {
    var trimWhitespace: String {
        type.trimmingCharacters(in: CharacterSet.whitespaces)
    }

    var escapedURL: String {
        type.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}

extension Driver: Extended {}
extension Ext where ExtendedType == Driver<String> {

    

    var number: Driver<String> {
        return type.map { $0.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression) }
    }

    func maxLength(_ length: Int) -> Driver<String> {
        return type.map { String($0.prefix(length)) }
    }

    var phoneNumberFormat: Driver<String> {
        return number.map {
            var formatted = ""
            for (index, num) in $0.enumerated() {
                if index == 3 || index == 7 {
                    formatted.append("-")
                }
                formatted.append(num)
            }
            return formatted
        }
    }
}


