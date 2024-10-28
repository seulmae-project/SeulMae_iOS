//
//  CurrentStatusView.swift
//  SeulMae
//
//  Created by 조기열 on 8/5/24.
//

import UIKit

final class AttendRequestStatusView: UIView {
    
    private let _progressLabel: UILabel = {
        let label = UILabel()
        label.text = "미완료"
        label.font = .pretendard(size: 14, weight: .bold)
        label.textColor = .primary
        return label
    }()
    
    let progressCountLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = .pretendard(size: 16, weight: .medium)
        return label
    }()
    
    private let _progressUnitsLabel: UILabel = {
        let label = UILabel()
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.14
        // Line height: 15 pt
        label.attributedText = NSMutableAttributedString(
            string: "개",
            attributes: [
                .font: UIFont.pretendard(size: 13, weight: .medium),
                NSAttributedString.Key.kern: -0.05,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ])        
        return label
    }()
    
    private let _completedLabel: UILabel = {
        let label = UILabel()
        label.text = "완료"
        label.font = .pretendard(size: 14, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    let completedCountLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = .pretendard(size: 16, weight: .medium)
        return label
    }()
    
    private let _completedUnitsLabel: UILabel = {
        let label = UILabel()
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.14
        // Line height: 15 pt
        label.attributedText = NSMutableAttributedString(
            string: "개",
            attributes: [
                .font: UIFont.pretendard(size: 13, weight: .medium),
                NSAttributedString.Key.kern: -0.05,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ])
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(hexCode: "EEEEEE")
        layer.cornerRadius = 12
        layer.cornerCurve = .continuous
        
        let bubbledProgressLabel = _progressLabel.bubbled(
            color: .lightPrimary, horizontal: 6.0, vertical: 4.0)
        let bubbledCompletedLabel = _completedLabel.bubbled(
            color: .primary, horizontal: 6.0, vertical: 4.0)

        let progressStack = UIStackView()
        progressStack.spacing = 2.0
        progressStack.alignment = .bottom
        progressStack.addArrangedSubview(progressCountLabel)
        progressStack.addArrangedSubview(_progressUnitsLabel)
      
        let completedStack = UIStackView()
        completedStack.spacing = 2.0
        completedStack.alignment = .bottom
        completedStack.addArrangedSubview(completedCountLabel)
        completedStack.addArrangedSubview(_completedUnitsLabel)
        
        let subviews = [bubbledProgressLabel, bubbledCompletedLabel, progressStack, completedStack,]
        
        subviews.forEach { subview in
            addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let hInset = CGFloat(8.0)
        let vInset = CGFloat(6.0)
            NSLayoutConstraint.activate([
            bubbledProgressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: hInset),
            bubbledProgressLabel.topAnchor.constraint(equalTo: topAnchor, constant: vInset),
            
            bubbledCompletedLabel.leadingAnchor.constraint(equalTo: bubbledProgressLabel.trailingAnchor, constant: 12),
            bubbledCompletedLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -hInset),
            bubbledCompletedLabel.topAnchor.constraint(equalTo: topAnchor, constant: vInset),
            
            progressStack.topAnchor.constraint(equalTo: bubbledProgressLabel.bottomAnchor, constant: 8.0),
            progressStack.centerXAnchor.constraint(equalTo: bubbledProgressLabel.centerXAnchor),
            progressStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -vInset),
            
            completedStack.topAnchor.constraint(equalTo: bubbledCompletedLabel.bottomAnchor, constant: 8.0),
            completedStack.centerXAnchor.constraint(equalTo: bubbledCompletedLabel.centerXAnchor),
            completedStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -vInset),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
