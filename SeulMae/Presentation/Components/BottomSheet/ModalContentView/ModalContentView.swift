//
//  ModalContentView.swift
//  SeulMae
//
//  Created by 조기열 on 6/17/24.
//

import UIKit

public protocol ModalContentView: NSObjectProtocol {
    var configuration: any ModalContentConfiguration { get set }
}

public protocol ModalContentConfiguration {
    func makeContentView() -> any UIView & ModalContentView
}
