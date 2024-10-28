//
//  AttendanceRequestContentView.swift
//  SeulMae
//
//  Created by 조기열 on 8/16/24.
//

import UIKit
import Kingfisher

final class AttendanceRequestContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var imageURL: String = ""
        var name: String = ""
        var isApprove: Bool = false
        var totalWorkTime: Double = 0
        var workStartDate: Date = Date()
        var workEndDate: Date = Date()
        
        func makeContentView() -> UIView & UIContentView {
            return AttendanceRequestContentView(self)
        }
    }
    
    private let memberImageView: UIImageView = .user()
    private let memberNameLabel: UILabel = .common(typographic: .headline)
    private let approvalLabel: UILabel = .common(typographic: .caption)
    private let startTimeLabel: UILabel = .common(title: "출근", typographic: .subhead)
    private let workStartTimeLabel: UILabel = .common(typographic: .footnote)
    private let endTimeLabel: UILabel = .common(title: "퇴근", typographic: .subhead)
    private let workEndTimeLabel: UILabel = .common(typographic: .footnote)
    private let totalTimeLabel: UILabel = .common(title: "총시간", typographic: .subhead)
    private let workTotalTimeLabel: UILabel = .common(typographic: .footnote)
    
    var configuration: UIContentConfiguration {
        didSet {
            apply(config: configuration)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        let totalTimeStack = UIStackView()
        totalTimeStack.spacing = 16
        totalTimeStack.addArrangedSubview(totalTimeStack)
        totalTimeStack.addArrangedSubview(workTotalTimeLabel)
        
        let startTimeStack = UIStackView()
        startTimeStack.spacing = 16
        startTimeStack.addArrangedSubview(startTimeStack)
        startTimeStack.addArrangedSubview(workStartTimeLabel)
        
        let endTimeStack = UIStackView()
        endTimeStack.spacing = 16
        endTimeStack.addArrangedSubview(endTimeLabel)
        endTimeStack.addArrangedSubview(workEndTimeLabel)
        
        let timeStack = UIStackView()
        timeStack.axis = .vertical
        timeStack.spacing = 8.0
        timeStack.addArrangedSubview(totalTimeStack)
        timeStack.addArrangedSubview(startTimeStack)
        timeStack.addArrangedSubview(endTimeStack)
        
        addSubview(memberImageView)
        addSubview(memberNameLabel)
        addSubview(approvalLabel)
        addSubview(timeStack)
        
        NSLayoutConstraint.activate([
            memberImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            memberImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            memberImageView.heightAnchor.constraint(equalToConstant: 40),
            memberImageView.widthAnchor.constraint(equalToConstant: 40),
            
            memberNameLabel.leadingAnchor.constraint(equalTo: memberImageView.trailingAnchor, constant: 8.0),
            memberNameLabel.topAnchor.constraint(equalTo: memberImageView.topAnchor),
            memberNameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: approvalLabel.leadingAnchor, constant: 8.0),
            
            approvalLabel.topAnchor.constraint(equalTo: memberImageView.topAnchor),
            approvalLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            timeStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            timeStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            timeStack.topAnchor.constraint(equalTo: memberImageView.bottomAnchor, constant: 8.0),
            timeStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func apply(config: UIContentConfiguration) {
        guard let config = config as? Configuration else { return }
        memberNameLabel.text = config.name
        approvalLabel.text = config.isApprove ? "인증" : "미인증"
        let rounded = config.totalWorkTime.rounded()
        workTotalTimeLabel.text = "\(Int(rounded)) 시간"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "a h:mm"
        workStartTimeLabel.text = dateFormatter.string(from: config.workStartDate)
        workEndTimeLabel.text = dateFormatter.string(from: config.workEndDate)
    }
}

