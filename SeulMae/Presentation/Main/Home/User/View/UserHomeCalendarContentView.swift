//
//  UserHomeCalendarContentView.swift
//  SeulMae
//
//  Created by 조기열 on 10/19/24.
//

import UIKit

final class UserHomeCalendarContentView: UIView, UIContentView {

    struct Configuration: UIContentConfiguration {
        var histories: [AttendanceHistory]? = []

        func makeContentView() -> UIView & UIContentView {
            return UserHomeCalendarContentView(self)
        }
    }

    private let calendarView = CalendarView()

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
        contentStack.addArrangedSubview(calendarView)

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

    private func apply(config: UIContentConfiguration) {
        guard let config = config as? Configuration else { return }

    }
}
