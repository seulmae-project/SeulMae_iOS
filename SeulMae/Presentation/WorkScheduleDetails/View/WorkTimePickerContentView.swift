//
//  WorkTimePickerContentView.swift
//  SeulMae
//
//  Created by 조기열 on 9/18/24.
//

import UIKit

final class WorkTimePickerContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var title: String = ""
        var date: Date = Date()
        var onChange: ((Date) -> Void)?
        
        func makeContentView() -> UIView & UIContentView {
            return WorkTimePickerContentView(self)
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(size: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private lazy var timeDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.addTarget(self, action: #selector(didDatePickerValueChange), for: .valueChanged)
        return picker
    }()

    private var onChange: ((Date) -> Void)?
    
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
        
                
        let contentStack = UIStackView()
        contentStack.alignment = .center
        contentStack.distribution = .equalCentering
        
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(timeDatePicker)
        
        addSubview(contentStack)
        
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didDatePickerValueChange(_ picker: UIDatePicker) {
        onChange?(picker.date)
    }
    
    private func apply(config: UIContentConfiguration) {
        guard let config = config as? Configuration else { return }
        titleLabel.text = config.title
        timeDatePicker.date = config.date
        onChange = config.onChange
    }
}

extension UICollectionViewCell {
    func timePickerContentConfiguration() -> WorkTimePickerContentView.Configuration {
        return WorkTimePickerContentView.Configuration()
    }
}
