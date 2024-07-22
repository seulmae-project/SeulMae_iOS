//
//  ToastView.swift
//  SeulMae
//
//  Created by 조기열 on 6/23/24.
//

import UIKit

class ToastView: UIView {
    
    private let titleLabel: UILabel = UILabel()
    
    private let iconImageView: UIImageView = UIImageView()
    
    init(title: String = "", icon: UIImage = .appLogo) {
        super.init(frame: .zero)
        
        titleLabel.text = title
        // titleLabel.font =
        // titleLabel.textColor =
        
        iconImageView.image = icon
            .withRenderingMode(.alwaysTemplate)
            .withTintColor(.white)
        
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
