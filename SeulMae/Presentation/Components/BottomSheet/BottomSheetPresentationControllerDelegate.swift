//
//  BottomSheetPresentationControllerDelegate.swift
//  SeulMae
//
//  Created by 조기열 on 6/17/24.
//

import UIKit

@objc protocol BottomSheetPresentationControllerDelegate: UIAdaptivePresentationControllerDelegate {
    @objc optional func prepareForBottomSheetPresentation(_ bottomSheet: BottomSheetPresentationController)
    @objc optional func bottomSheetPresentationControllerDidDismissBottomSheet(_ bottomSheet: BottomSheetPresentationController)
    @objc optional func bottomSheetPresentationControllerDismissalAnimationCompleted(_ bottomSheet: BottomSheetPresentationController)
    @objc optional func bottomSheetWillChangeState(_ bottomSheet: BottomSheetPresentationController, sheetState: SheetState)
    @objc optional func bottomSheetDidChangeYOffset(_ bottomSheet: BottomSheetPresentationController, yOffset: CGFloat)
}
