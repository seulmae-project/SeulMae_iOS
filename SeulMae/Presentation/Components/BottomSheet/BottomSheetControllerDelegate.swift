//
//  BottomSheetControllerDelegate.swift
//  SeulMae
//
//  Created by 조기열 on 6/19/24.
//

import Foundation

protocol BottomSheetControllerDelegate: AnyObject {
    func bottomSheetControllerDidDismissBottomSheet(_ controller: BottomSheetController)
    func bottomSheetControllerStateChanged(_ controller: BottomSheetController, state: SheetState)
    func bottomSheetControllerDidChangeYOffset(_ controller: BottomSheetController, yOffset: CGFloat)
}
