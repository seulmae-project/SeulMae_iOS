//
//  SearchBarView.swift
//  SeulMae
//
//  Created by 조기열 on 8/15/24.
//

import UIKit

final class SearchBarView: UIView {
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .search
        return imageView
    }()
    
    let queryTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "근무지 검색"
        return textfield
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .cloudy
        layer.cornerRadius = 8.0
        layer.cornerCurve = .continuous
        
        addSubview(iconImageView)
        addSubview(queryTextField)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        queryTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            
            queryTextField.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            queryTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            queryTextField.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
            queryTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
