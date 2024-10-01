//
//  Separator.swift
//  SeulMae
//
//  Created by 조기열 on 10/1/24.
//

import UIKit

class SeparatorSupplementaryView: UICollectionReusableView {
    
    static let reuseIdentifier = "separator-supplementary-reuse-identifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .signinSeparator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
