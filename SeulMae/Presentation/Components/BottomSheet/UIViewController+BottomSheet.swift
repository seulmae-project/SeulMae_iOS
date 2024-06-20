//
//  UIViewController+MaterialBottomSheet.swift
//  SeulMae
//
//  Created by 조기열 on 6/19/24.
//

import UIKit

extension UIViewController {
    var bottomSheetPresentationController: BottomSheetPresentationController? {
        return self.presentationController as? BottomSheetPresentationController
    }
}
