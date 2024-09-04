//
//  _TextView.swift
//  SeulMae
//
//  Created by 조기열 on 7/23/24.
//

import UIKit

final class _TextView: UITextView {
    private class PHTextViewDelegator: NSObject, UITextViewDelegate {
        func textViewDidChange(_ textView: UITextView) {
            print("텍스트가 변경되었습니다: \(textView.text ?? "")")
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            guard let phTextView = textView as? _TextView else { return }
            if phTextView.text == phTextView.placeholder {
                phTextView.text = nil
            }
            phTextView.applyDefaultAttr()
            textView.textColor = .label
        }
        
       
        func textViewDidEndEditing(_ textView: UITextView) {
            guard let phTextView = textView as? _TextView else { return }
            let trimmedText = phTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedText.isEmpty {
                phTextView.text = phTextView.placeholder
                phTextView.textColor = .secondaryLabel
            }
        }
    }
    
    func applyDefaultAttr() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4.0
        paragraphStyle.lineBreakStrategy = .hangulWordPriority
        var attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.label
        ]
        
        if let font {
            attributes[.font] = font
        }

        attributedText = NSMutableAttributedString(string: text, attributes: attributes)
    }
    
    override var text: String! {
        didSet {
            if text != _placeholder {
                textColor = .label
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
