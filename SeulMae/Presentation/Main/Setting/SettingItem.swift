//
//  SettingItem.swift
//  SeulMae
//
//  Created by 조기열 on 9/6/24.
//

import UIKit

struct SettingItem: Hashable {
    private let identifier = UUID()
    
    let title: String
    let text: String
    let image: UIImage
    let section: SettingViewController.Section
}

extension SettingViewController.Section {
    var menus: [SettingItem] {
        switch self {
        case .account:
            return [
                .init(title: "로그아웃", text: "", image: ._1, section: self),
                .init(title: "개인/보안", text: "", image: ._1, section: self),
            ]
        case .system:
            return [
                .init(title: "알림", text: "", image: ._1, section: self),
            ]
        case .info:
            return [
                .init(title: "문의하기", text: "", image: ._1, section: self),
                .init(title: "버전", text: "1.0.0", image: ._1, section: self),
            ]
        }
    }
}
