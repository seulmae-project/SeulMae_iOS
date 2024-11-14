//
//  AttHistoryContentView.swift
//  SeulMae
//
//  Created by 조기열 on 11/13/24.
//

import UIKit

class AttHistoryContentView: UIView, UIContentView {
  struct Configuration: UIContentConfiguration {
    var att: AttendanceHistory?

    func makeContentView() -> UIView & UIContentView {
      return AttHistoryContentView(self)
    }
  }

  let scheduleNameLabel = UILabel()
    .ext.font(.pretendard(size: 14, weight: .regular))

  let _dividerLabel = UILabel()
    .ext.text("|")
    .ext.font(.pretendard(size: 14, weight: .regular))
    .ext.color(.ext.hex("737681"))

  let scheduleTimeLabel = UILabel()
    .ext.font(.pretendard(size: 14, weight: .regular))
    .ext.color(.ext.hex("737681"))

  let usernameLabel = UILabel()
    .ext.font(.pretendard(size: 16, weight: .medium))

  let totalWageLabel = UILabel()
    .ext.font(.pretendard(size: 20, weight: .bold))

  let totalWorkTimeLabel = UILabel()
    .ext.font(.pretendard(size: 14, weight: .regular))
    .ext.color(.ext.hex("737681"))

  var configuration: UIContentConfiguration {
    didSet {
      apply(config: configuration)
    }
  }

  init(_ configuration: UIContentConfiguration) {
    self.configuration = configuration
    super.init(frame: .zero)

    let sheduleStack = UIStackView()
    sheduleStack.spacing = 4.0
    [scheduleNameLabel, _dividerLabel, scheduleTimeLabel]
      .forEach(sheduleStack.addArrangedSubview(_:))
    scheduleTimeLabel.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)

    let rightStack = UIStackView()
    rightStack.spacing = 4.0
    rightStack.alignment = .trailing
    rightStack.axis = .vertical
    [totalWageLabel, totalWorkTimeLabel]
      .forEach(rightStack.addArrangedSubview(_:))

    let usernameStack = UIStackView()
    usernameStack.alignment = .top
    usernameStack.distribution = .equalCentering
    [usernameLabel, rightStack]
      .forEach(usernameStack.addArrangedSubview(_:))

    let contentStack = UIStackView()
    contentStack.axis = .vertical
    contentStack.spacing = 8.0
    [sheduleStack, usernameStack]
      .forEach(contentStack.addArrangedSubview(_:))

    let border: UIView = .separator
    let views = [contentStack, border]
    views.forEach {
      addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let insets = CGFloat(8.0)
    NSLayoutConstraint.activate([
      contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets),
      contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets),
      contentStack.topAnchor.constraint(equalTo: topAnchor, constant: insets),
      contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets),

      border.leadingAnchor.constraint(equalTo: leadingAnchor),
      border.trailingAnchor.constraint(equalTo: trailingAnchor),
      border.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override var intrinsicContentSize: CGSize {
    CGSize(width: 0, height: 44)
  }

  private func apply(config: UIContentConfiguration) {
    guard let config = config as? Configuration,
          let att = config.att else { return }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    let startTime = dateFormatter.string(from: att.workStartTime)
    let endTime = dateFormatter.string(from: att.workEndTime)
    scheduleNameLabel.text = "스케줄 이름"
    scheduleTimeLabel.text = "스케줄 시간"
    usernameLabel.text = "유저 이름"
    totalWageLabel.text = "\(att.wage)원"
    totalWorkTimeLabel.text = startTime + " ~ " + endTime
  }
}
