//
//  CalendarContentView.swift
//  SeulMae
//
//  Created by 조기열 on 10/12/24.
//

import UIKit

class CalendarContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var date: Date?
        
        func makeContentView() -> UIView & UIContentView {
            return CalendarContentView(self)
        }
    }
    
    let dayLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 18, weight: .semibold)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.layer.cornerRadius = 8.0
        l.layer.cornerCurve = .continuous
        l.clipsToBounds = true
        l.textAlignment = .center
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
                
        self.addSubview(dayLabel)
        
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
        CGSize(width: 0, height: 44)
    }
        
    func apply(config: UIContentConfiguration) {
        guard let config = config as? Configuration else { return }

    }
}


