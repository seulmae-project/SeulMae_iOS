//
//  SearchedQueryContentView.swift
//  SeulMae
//
//  Created by 조기열 on 10/20/24.
//

import UIKit

final class SearchedQueryContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var query: String?

        func makeContentView() -> UIView & UIContentView {
            return SearchedQueryContentView(self)
        }
    }

    private let queryLabel: UILabel = .common(size: 14, weight: .medium)
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "BCC7DD")
        return view
    }()

    var configuration: UIContentConfiguration {
        didSet {
            apply(config: configuration)
        }
    }

    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        let views = [queryLabel, separatorView]
        views.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        let insets = CGFloat(16)
        NSLayoutConstraint.activate([
            queryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets),
            queryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets),
            queryLabel.topAnchor.constraint(equalTo: topAnchor, constant: insets),
            queryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets),
            
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.6)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }

    private func apply(config: UIContentConfiguration) {
        guard let config = config as? Configuration else { return }
        queryLabel.text = config.query
    }
}
