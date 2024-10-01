//
//  BigButton.swift
//  SeulMae
//
//  Created by 조기열 on 10/1/24.
//

import UIKit

class BigButton: UIView {
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let titlelabel: UILabel = .callout(title: "String")
    
    let descriptionlabel: UILabel = .callout(title: "String")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
