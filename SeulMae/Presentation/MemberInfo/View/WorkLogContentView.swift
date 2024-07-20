//
//  WorkLogContentView.swift
//  SeulMae
//
//  Created by 조기열 on 7/20/24.
//

import UIKit

final class WorkLogContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var isAccept: Bool = false
        var date: Date?
        var duration: String = ""
        var wage: String = ""
        
        func makeContentView() -> UIView & UIContentView {
            return WorkLogContentView(self)
        }
    }
        
    private let acceptStateLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12)
        l.textColor = .white
        l.backgroundColor = .red
        l.heightAnchor.constraint(equalToConstant: 24).isActive = true
        l.layer.cornerRadius = 12
        l.layer.cornerCurve = .continuous
        return l
    }()
    
    private let dateLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .semibold)
        return l
    }()
    
    private let totalHoursLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .semibold)
        return l
    }()
    
    private let _wageLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .semibold)
        l.text = AppText.wage
        return l
    }()
    
    private let wageLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14)
        return l
    }()
    
    private let _hoursLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .semibold)
        l.text = AppText.time
        return l
    }()
    
    private let hoursLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14)
        return l
    }()
    
    private let totalWageLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .semibold)
        return l
    }()
            
    var configuration: UIContentConfiguration {
        didSet {
            apply(config: configuration)
        }
    }
                
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        let stateStack = UIStackView(arrangedSubviews: [
            acceptStateLabel, dateLabel, totalHoursLabel
        ])
        stateStack.spacing = 8.0
        
        let hoursStack = UIStackView(arrangedSubviews: [
            _hoursLabel, hoursLabel,
        ])
        hoursStack.spacing = 8.0
        
        let wageStack = UIStackView(arrangedSubviews: [
            _wageLabel, wageLabel, totalWageLabel
        ])
        wageStack.spacing = 8.0
        
        addSubview(stateStack)
        addSubview(hoursStack)
        addSubview(wageStack)
        
        NSLayoutConstraint.activate([
            stateStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stateStack.topAnchor.constraint(equalTo: topAnchor),
            stateStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            hoursStack.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            hoursStack.topAnchor.constraint(equalTo: stateStack.bottomAnchor, constant: 4.0),
            
            wageStack.leadingAnchor.constraint(equalTo: hoursStack.leadingAnchor),
            wageStack.topAnchor.constraint(equalTo: hoursStack.bottomAnchor, constant: 4.0),
            wageStack.trailingAnchor.constraint(equalTo: stateStack.trailingAnchor),
            wageStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        totalHoursLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        totalWageLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }
        
    private func apply(config: UIContentConfiguration) {
        guard let config = config as? Configuration else { return }
        acceptStateLabel.text = config.isAccept ? AppText.ok : AppText.no
        dateLabel.text = config.date?.description
        wageLabel.text = config.wage
        hoursLabel.text = config.duration
    }
}
