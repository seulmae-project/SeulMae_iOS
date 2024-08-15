//
//  SheetContainerViewDelegate.swift
//  SeulMae
//
//  Created by 조기열 on 6/17/24.
//

import UIKit

protocol SheetContainerViewDelegate: AnyObject {
    func sheetContainerViewDidHide(_ containerView: SheetContainerView)
    func sheetContainerViewWillChangeState(_ containerView: SheetContainerView, sheetState: SheetState)
    func sheetContainerViewDidChangeYOffset(_ containerView: SheetContainerView, yOffset: CGFloat)
}
