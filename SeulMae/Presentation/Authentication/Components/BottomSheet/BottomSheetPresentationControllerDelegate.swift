//
//  BottomSheetPresentationControllerDelegate.swift
//  SeulMae
//
//  Created by 조기열 on 6/17/24.
//

import UIKit

protocol BottomSheetPresentationControllerDelegate: UIAdaptivePresentationControllerDelegate {
    func prepareForBottomSheetPresentation(_ bottomSheet: BottomSheetPresentationController)
    func bottomSheetPresentationControllerDidDismissBottomSheet(_ bottomSheet: BottomSheetPresentationController)
    func bottomSheetPresentationControllerDismissalAnimationCompleted(_ bottomSheet: BottomSheetPresentationController)
    func bottomSheetWillChangeState(_ bottomSheet: BottomSheetPresentationController, sheetState: SheetState)
    func bottomSheetDidChangeYOffset(_ bottomSheet: BottomSheetPresentationController, yOffset: CGFloat)
}

extension BottomSheetPresentationControllerDelegate {
    func prepareForBottomSheetPresentation(_ bottomSheet: BottomSheetPresentationController) {}
    func bottomSheetPresentationControllerDidDismissBottomSheet(_ bottomSheet: BottomSheetPresentationController) {}
    func bottomSheetPresentationControllerDismissalAnimationCompleted(_ bottomSheet: BottomSheetPresentationController) {}
    func bottomSheetWillChangeState(_ bottomSheet: BottomSheetPresentationController, sheetState: SheetState) {}
    func bottomSheetDidChangeYOffset(_ bottomSheet: BottomSheetPresentationController, yOffset: CGFloat) {}
}
