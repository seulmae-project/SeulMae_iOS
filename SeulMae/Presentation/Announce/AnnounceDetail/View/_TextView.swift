//
//  _TextView.swift
//  SeulMae
//
//  Created by 조기열 on 7/23/24.
//

import UIKit

final class _TextView: UITextView {
    private class PHTextViewDelegator: NSObject, UITextViewDelegate {
        fileprivate var placeholder: String?
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            guard let placeholder else { return }
            if textView.text == placeholder {
                textView.text = nil
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4.0
                paragraphStyle.lineBreakStrategy = .hangulWordPriority
                var typingAttributes: [NSAttributedString.Key: Any] = [
                    .paragraphStyle: paragraphStyle,
                    .foregroundColor: UIColor.label
                ]
                
                if let font = textView.font {
                    typingAttributes[.font] = font
                }

                textView.typingAttributes = typingAttributes
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            guard let placeholder else { return }
            let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedText.isEmpty {
                textView.text = placeholder
                textView.textColor = .secondaryLabel
            }
        }
    }
    
    private var _placeholder: String?
    var placeholder: String? {
        get {
            return _placeholder
        }
        
        set(newValue) {
            _placeholder = newValue
            delegator.placeholder = newValue
            if let newValue {
                let attributedText = NSMutableAttributedString(
                    string: newValue,
                    attributes: [
                        .foregroundColor: UIColor.secondaryLabel
                    ]
                )
                if let font {
                    let additionalAttributes: [NSAttributedString.Key: Any] = [
                        .font: font
                    ]
                    attributedText.addAttributes(additionalAttributes, range: NSRange(location: 0, length: attributedText.length))
                }
                
                self.attributedText = attributedText
            }
        }
    }
    
    private var delegator: PHTextViewDelegator
    
    init() {
        self.delegator = PHTextViewDelegator()
        super.init(frame: .zero, textContainer: nil)
        self.delegate = delegator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension String {
    func spaced(_ spacing: CGFloat = 4.0, alignment: NSTextAlignment = .center) -> NSMutableAttributedString {
        let attrString = NSMutableAttributedString(string: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        paragraphStyle.lineBreakStrategy = .hangulWordPriority
        paragraphStyle.alignment = alignment
        let range = NSMakeRange(0, attrString.length)
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        return attrString
    }
}
