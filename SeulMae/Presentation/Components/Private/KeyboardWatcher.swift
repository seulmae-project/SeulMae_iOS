//
//  KeyboardWatcher.swift
//  SeulMae
//
//  Created by 조기열 on 6/18/24.
//

import UIKit

extension Notification.Name {
    static let KeyboardWatcherKeyboardWillShow = Notification.Name("KeyboardWatcherKeyboardWillShowNotification")
    static let KeyboardWatcherKeyboardWillHide = Notification.Name("KeyboardWatcherKeyboardWillHideNotification")
    static let KeyboardWatcherKeyboardWillChangeFrame = Notification.Name("KeyboardWatcherKeyboardWillChangeFrameNotification")
}

class KeyboardWatcher: NSObject {
    
    class func animationDuration(from notification: Notification) -> TimeInterval {
        guard notification.name == .KeyboardWatcherKeyboardWillShow ||
                notification.name == .KeyboardWatcherKeyboardWillHide ||
                notification.name == .KeyboardWatcherKeyboardWillChangeFrame else {
            assertionFailure("Cannot extract the animation duration from a non-keyboard notification.")
            return 0.0
        }
        
        return (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
    }
    
    class func animationCurveOption(from notification: Notification) -> UIView.AnimationOptions {
        guard notification.name == .KeyboardWatcherKeyboardWillShow ||
                notification.name == .KeyboardWatcherKeyboardWillHide ||
                notification.name == .KeyboardWatcherKeyboardWillChangeFrame else {
            assertionFailure("Cannot extract the animation curve option from a non-keyboard notification.")
            return .curveEaseInOut
        }
        
        let animationCurve = UIView.AnimationCurve(rawValue: (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue ?? 0) ?? .easeInOut
        return animationOptions(withCurve: animationCurve)
    }
    
    private static func animationOptions(withCurve curve: UIView.AnimationCurve) -> UIView.AnimationOptions {
        switch curve {
        case .easeInOut:
            return .curveEaseInOut
        case .easeIn:
            return .curveEaseIn
        case .easeOut:
            return .curveEaseOut
        case .linear:
            return .curveLinear
        @unknown default:
            return UIView.AnimationOptions(rawValue: UInt(curve.rawValue << 16))
        }
    }

    static let shared = KeyboardWatcher()
    
    private var keyboardFrame: CGRect = .zero
   
    var visibleKeyboardHeight: CGFloat {
        return keyboardFrame.height
    }

    private override init() {
        super.init()
        let defaultCenter = NotificationCenter.default
        defaultCenter.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        defaultCenter.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        defaultCenter.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func updateKeyboardOffset(with userInfo: [AnyHashable: Any]?) {
        // On iOS 8, the window orientation is corrected logically after transforms, so there is
        // no need to swap the width and height like we had to on iOS 7 and below..
        guard let userInfo = userInfo, let keyboardRectValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            self.keyboardFrame = .zero
            return
        }
        
        let keyboardRect = keyboardRectValue.cgRectValue
        if keyboardRect.isEmpty {
            self.keyboardFrame = .zero
            return
        }
            
        #if targetEnvironment(simulator)
        self.keyboardFrame = .zero
        #else
        guard let keyWindowBounds = UIApplication.shared.keyWindow?.bounds else {
            self.keyboardFrame = .zero
            return
        }
        
        let screenBounds = UIScreen.main.bounds
        let intersection = keyboardRect.intersection(screenBounds)
        let dockedKeyboard = keyWindowBounds.maxY <= keyboardRect.maxY
        
        self.keyboardFrame = dockedKeyboard && !intersection.isEmpty ? intersection : .zero
        #endif
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        updateKeyboardOffset(with: notification.userInfo)
        NotificationCenter.default.post(name: .KeyboardWatcherKeyboardWillShow, object: self, userInfo: notification.userInfo)
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        updateKeyboardOffset(with: notification.userInfo)
        NotificationCenter.default.post(name: .KeyboardWatcherKeyboardWillChangeFrame, object: self, userInfo: notification.userInfo)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        self.keyboardFrame = .zero
        NotificationCenter.default.post(name: .KeyboardWatcherKeyboardWillHide, object: self, userInfo: notification.userInfo)
    }
}
