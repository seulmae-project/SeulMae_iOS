//
//  AttListPageViewController.swift
//  SeulMae
//
//  Created by 조기열 on 11/12/24.
//

import UIKit

class AttListPageViewController: UIPageViewController {

    convenience init() {
        self.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
}
