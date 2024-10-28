//
//  WorkStatusView.swift
//  SeulMae
//
//  Created by 조기열 on 6/28/24.
//

import UIKit

final class WorkStatusView: UIView {
    
//    private let leftTimeLabel: UILabel = {
//        let label = UILabel()
//        label.font = .pretendard(size: 17, weight: .regular)
//        return label
//    }()
//    
//    private let leftTimeOutlet: UILabel = {
//        let label = UILabel()
//        label.font = .pretendard(size: 17, weight: .regular)
//        return label
//    }()
//    
//    private let totalMonthlySalaryLabel: UILabel = {
//        let label = UILabel()
//        label.font = .pretendard(size: 17, weight: .regular)
//        return label
//    }()
//    
//    private let amountEarnedToday: UILabel = {
//        let label = UILabel()
//        label.font = .pretendard(size: 17, weight: .regular)
//        return label
//    }()
//    
//    let progressView: UIProgressView = UIProgressView()

    lazy var label: UILabel = makeLabel(font: .systemFont(ofSize: 16))
    
    let label2: UILabel = {
        let label = UILabel()
        label.textColor = .graphite
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    let label3: UILabel = {
        let label = UILabel()
        label.textColor = .graphite
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    let label4: UILabel = {
        let label = UILabel()
        label.textColor = .graphite
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        return label
    }()
    
    let progressView: UIProgressView = UIProgressView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .cloudy
        self.layer.cornerRadius = 16
        self.layer.cornerCurve = .continuous
        
        let leftLabelVStack = UIStackView(arrangedSubviews: [
            label, label2
        ])
        leftLabelVStack.axis = .vertical
        leftLabelVStack.spacing = 4.0
        
        let rightLabelVStack = UIStackView(arrangedSubviews: [
            label3, label4
        ])
        rightLabelVStack.axis = .vertical
        rightLabelVStack.spacing = 4.0
        
        let labelHStack = UIStackView(arrangedSubviews: [
            leftLabelVStack, rightLabelVStack
        ])
        labelHStack.distribution = .equalCentering
        
        progressView.progressTintColor = .primary
        progressView.trackTintColor = .systemBackground
        
        let vStack = UIStackView(arrangedSubviews: [
            labelHStack, progressView
        ])
        vStack.axis = .vertical
        vStack.spacing = 8.0

        addSubview(vStack)
        
        vStack.snp.makeConstraints { make in
            make.leading.top.bottom.trailing.equalToSuperview()
                .inset(16)
        }
    }
    
    func makeLabel(font: UIFont) -> UILabel {
        let label = UILabel()
        label.textColor = .graphite
        label.font = font
        return label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
