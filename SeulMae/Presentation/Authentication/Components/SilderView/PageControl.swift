//
//  PageIndicator.swift
//  SeulMae
//
//  Created by 조기열 on 6/13/24.
//

import UIKit

public protocol PageControl: UIView {
    var currentPage: Int { get set }
    var numberOfPages: Int { get set }
}

extension UIPageControl: PageControl {

    open override func sizeToFit() {
        var frame = self.frame
        frame.size = size(forNumberOfPages: numberOfPages)
        frame.size.height = 30
        self.frame = frame
    }

    public static var `default`: UIPageControl {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor(dynamicProvider: { $0.userInterfaceStyle == .dark ? .white : .lightGray })
        pageControl.pageIndicatorTintColor = UIColor(dynamicProvider: { $0.userInterfaceStyle == .dark ? .systemGray : .black })
        return pageControl
    }
}

public class LabelPageControl: UILabel, PageControl {

    public var numberOfPages: Int = 0 {
        didSet {
            updateText()
        }
    }

    public var currentPage: Int = 0 {
        didSet {
            updateText()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        textAlignment = .center
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        textAlignment = .center
    }
    
    public override func sizeToFit() {
        let maximumString = String(repeating: "8", count: numberOfPages) as NSString
        self.frame.size = maximumString.size(withAttributes: [.font: font as Any])
    }

    private func updateText() {
        text = "\(currentPage + 1)/\(numberOfPages)"
    }
}
