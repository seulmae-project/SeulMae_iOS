//
//  ModalListContentView.swift
//  SeulMae
//
//  Created by 조기열 on 6/17/24.
//

import UIKit

class ModalListContentView: UIView, ModalContentView {
    
    struct Configuration: ModalContentConfiguration {
        func makeContentView() -> any UIView & ModalContentView {
            ModalListContentView(configuration: self)
        }
    }

    var configuration: ModalContentConfiguration

    init(configuration: ModalContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }
}
