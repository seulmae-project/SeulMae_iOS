//
//  UIScrollView+Ext.swift
//  SeulMae
//
//  Created by 조기열 on 10/27/24.
//

import UIKit

extension Ext where ExtendedType: UIScrollView {

    static func common(refreshControl: UIRefreshControl) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        scrollView.alwaysBounceVertical = true
        scrollView.refreshControl = refreshControl
        return scrollView
    }

    func refresh(_ refreshControl: UIRefreshControl) -> ExtendedType {
        type.refreshControl = refreshControl
        return type
    }
}
