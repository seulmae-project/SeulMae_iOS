//
//  BottomSheetTransitionControllerDelegate.swift
//  SeulMae
//
//  Created by 조기열 on 6/20/24.
//

import Foundation

@objc protocol BottomSheetTransitionControllerDelegate: AnyObject {
    
    @objc optional func didDismissBottomSheetTransitionController(_ controller: BottomSheetTransitionController)
}
