//
//  DayContentView.swift
//  SeulMae
//
//  Created by 조기열 on 7/1/24.
//

import UIKit

class DayContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var day: Int? = nil
        var status: CalendarItem.DayState = .normal
        
        func makeContentView() -> UIView & UIContentView {
            return DayContentView(self)
        }
    }
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 14, weight: .semibold)
        label.layer.cornerRadius = 9.0
        label.layer.cornerCurve = .continuous
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    var configuration: UIContentConfiguration {
        didSet {
            apply(config: configuration)
        }
    }
            
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
                
        self.addSubview(dayLabel)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            dayLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            dayLabel.topAnchor.constraint(equalTo: topAnchor),
            dayLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            dayLabel.widthAnchor.constraint(equalTo: dayLabel.heightAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 32)
    }
        
    func apply(config: UIContentConfiguration) {
        guard let config = config as? Configuration else { return }
        dayLabel.text = config.day?.description ?? ""
        switch config.status {
        case .normal:
            dayLabel.isHidden = false
            dayLabel.textColor = UIColor(hexCode: "D9DBE9")
            dayLabel.backgroundColor = UIColor(hexCode: "F2F3FD")
        case .highlight:
            dayLabel.isHidden = false
            dayLabel.textColor = .white
            dayLabel.backgroundColor = UIColor(hexCode: "4C71F5")
        case .none:
            dayLabel.isHidden = true
        }
    }
}


