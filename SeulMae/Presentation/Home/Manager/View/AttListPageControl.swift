//
//  AttListPageControl.swift
//  SeulMae
//
//  Created by 조기열 on 11/11/24.
//

import UIKit

class AttListPageControl: UIView {
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.tag = 0
        button.setTitle("완료", for: .normal)
        button.titleLabel?.font = .pretendard(size: 14, weight: .bold)
        button.setTitleColor(.ext.hex("4C71F5"), for: .selected)
        button.setTitleColor(.ext.hex("BCC7DD"), for: .normal)
        button.addTarget(self, action: #selector(onButtonTap(_:)), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return button
    }()

    private lazy var undoneButton: UIButton = {
        let button = UIButton()
        button.tag = 1
        button.setTitle("미완료", for: .normal)
        button.titleLabel?.font = .pretendard(size: 14, weight: .bold)
        button.setTitleColor(.ext.hex("4C71F5"), for: .selected)
        button.setTitleColor(.ext.hex("BCC7DD"), for: .normal)
        button.addTarget(self, action: #selector(onButtonTap(_:)), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return button
    }()

    private let doneLine: UIView = {
        let view = UIView()
        view.backgroundColor = .ext.hex("E4E7F2")
        return view
    }()

    private let undoneLine: UIView = {
        let view = UIView()
        view.backgroundColor = .ext.hex("E4E7F2")
        return view
    }()

    private var isDoneButtonSelected: Bool = true
    var currentPage = 0 {
        didSet {
            if oldValue != currentPage {
                changePage(index: currentPage)
            }
        }
    }

    var onChange: ((Int) -> Void)?

    func changePage(index: Int) {
        let isDone = (index == 0)
        isDoneButtonSelected = isDone
        doneButton.isSelected = isDone
        undoneButton.isSelected = !isDone
        doneLine.backgroundColor = isDone ? .ext.hex("4C71F5") : .ext.hex("E4E7F2")
        undoneLine.backgroundColor = !isDone ? .ext.hex("4C71F5") : .ext.hex("E4E7F2")
    }

    convenience init() {
        self.init(frame: .zero)

        doneButton.isSelected = true
        doneLine.backgroundColor = .ext.hex("4C71F5")

        let buttonStack = UIStackView()
        buttonStack.distribution = .fillEqually
        [doneButton, undoneButton]
            .forEach(buttonStack.addArrangedSubview(_:))

        let views = [buttonStack, doneLine, undoneLine]
        views.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            buttonStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonStack.topAnchor.constraint(equalTo: topAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: bottomAnchor),

            doneLine.heightAnchor.constraint(equalToConstant: 2.0),
            doneLine.leadingAnchor.constraint(equalTo: doneButton.leadingAnchor),
            doneLine.trailingAnchor.constraint(equalTo: doneButton.trailingAnchor),
            doneLine.bottomAnchor.constraint(equalTo: doneButton.bottomAnchor),

            undoneLine.heightAnchor.constraint(equalToConstant: 2.0),
            undoneLine.leadingAnchor.constraint(equalTo: undoneButton.leadingAnchor),
            undoneLine.trailingAnchor.constraint(equalTo: undoneButton.trailingAnchor),
            undoneLine.bottomAnchor.constraint(equalTo: undoneButton.bottomAnchor),
        ])
    }

    @objc
    private func onButtonTap(_ sender: UIButton) {
        currentPage = sender.tag
        onChange?(sender.tag)
    }
}

