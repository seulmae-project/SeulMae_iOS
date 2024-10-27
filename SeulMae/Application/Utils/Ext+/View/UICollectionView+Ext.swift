//
//  UICollectionView+Ext.swift
//  SeulMae
//
//  Created by 조기열 on 10/27/24.
//

import UIKit

extension Ext where ExtendedType == UICollectionView {
    static func common(frame: CGRect = .zero,
                       layout: UICollectionViewLayout,
                       backgroundColor: UIColor? = nil,
                       emptyView: UIView? = nil,
                       refreshControl: UIRefreshControl) -> UICollectionView {
        let collectionView = UICollectionView(
            frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = backgroundColor
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.refreshControl = refreshControl
        collectionView.allowsMultipleSelection = true
        // collectionView.isUserInteractionEnabled = true

        if let emptyView { collectionView.backgroundView = emptyView }
        return collectionView
    }
}
