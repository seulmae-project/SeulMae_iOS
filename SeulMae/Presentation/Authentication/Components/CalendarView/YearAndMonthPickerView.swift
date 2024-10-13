//
//  YearAndMonthPickerView.swift
//  SeulMae
//
//  Created by 조기열 on 10/12/24.
//

import UIKit

class YearAndMonthPickerView: UIPickerView {
  enum Component: Int {
    case year, month
  }

  var minYear: Int!
  var maxYear: Int!

  var years: [String] {
    (minYear...maxYear).map(String.init(_:))
  }

  let months = [
    "01", "02", "03", "04", "05", "06",
    "07", "08", "09", "10", "11", "12"
  ]

  override init(frame: CGRect) {
    super.init(frame: frame)
    onLoad()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func onLoad() {
    let calendar = Calendar.current
    maxYear = calendar.component(.year, from: .ext.now)
    minYear = 2000

    self.delegate = self
    self.dataSource = self

    let currentYearIndex = years.firstIndex(of: String(maxYear)) ?? 0
    let currentMonthIndex = calendar.component(.month, from: .ext.now)

    selectRow(currentMonthIndex, inComponent: Component.month.rawValue, animated: false)
    selectRow(currentYearIndex, inComponent: Component.year.rawValue, animated: false)
  }
}

extension YearAndMonthPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 2
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return (component == Component.year.rawValue) ? years.count : months.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    let isYear = (component == Component.year.rawValue)
    return isYear ?  years[row] : months[row] // (row % years.count)
  }

  func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
    return CGFloat(44)
  }
}
