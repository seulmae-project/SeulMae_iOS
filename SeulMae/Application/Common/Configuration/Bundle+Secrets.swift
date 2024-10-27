//
//  Bundle+Secrets.swift
//  SeulMae
//
//  Created by 조기열 on 8/6/24.
//

import Foundation

extension Bundle {
    
    //  os_log(.error, log: .default, "⛔️ API KEY를 가져오는데 실패하였습니다.")
    
    private func load(key: String) -> String {
        guard let info = infoDictionary,
              let value = info[key] as? String else {
            Swift.fatalError("Failed to create URL instance")
        }
        return value
    }
    
    var baseURL: String {
        load(key: "BaseURL")
    }
    
    var nativeAPPKey: String {
        load(key: "NativeAPPKey")
    }
    
    var javaScriptKey: String {
        load(key: "JavaScriptKey")
    }

    var naverClientId: String {
        load(key: "NaverClientId")
    }
}
