//
//  AddressInputFormView.swift
//  SeulMae
//
//  Created by 조기열 on 10/20/24.
//

import UIKit

class AddressInputFormView: UIView {

    // address stack
    let addressStack: UIStackView = UIStackView()
    let guideLabel: UILabel = .common(title: "주소 등록을 위해, 아래에서 주소를 검색해 주세요", size: 16, weight: .bold, color: UIColor(hexCode: "4C71F5"))
    let searchAddressButton: UIButton = .common(title: "주소 검색", size: 18, weight: .semibold)

    // sub address stack
    // Show after seached address
    let subAddressStack: UIStackView = UIStackView()
    let researchAddressButton: UIButton = .common(title: "재검색")
    let roadAddressLabel: UILabel = .common(size: 16, weight: .bold, color: UIColor(hexCode: "4C71F5")) // 도로명 주소
    let lotNumberAddressLabel: UILabel = .common(size: 12, weight: .regular, color: UIColor(hexCode: "313946")) // 지번 주소
    let subAddresssTextField: UITextField = .common(placeholder: "상세 주소(건물명 / 호)를 입력해주세요", size: 16, weight: .regular, backgroundColor: .white)
    let subAddressValidationResultsLabel: UILabel = .footnote()

    var onChange: ((String, String, String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 8.0
        layer.cornerCurve = .continuous
        backgroundColor = UIColor(hexCode: "F2F5FF")

        addressStack.axis = .vertical
        addressStack.spacing = 12
        [guideLabel, searchAddressButton]
            .forEach(addressStack.addArrangedSubview(_:))

        subAddressStack.isHidden = true
        subAddressStack.axis = .vertical
        subAddressStack.spacing = 12
        [roadAddressLabel, lotNumberAddressLabel, subAddresssTextField, subAddressValidationResultsLabel, researchAddressButton]
            .forEach(subAddressStack.addArrangedSubview(_:))

        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.directionalLayoutMargins = Ext.all(20)
        contentStack.isLayoutMarginsRelativeArrangement = true
        [addressStack, subAddressStack]
            .forEach(contentStack.addArrangedSubview(_:))

        addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchAddressButton.heightAnchor.constraint(equalToConstant: 56),
            researchAddressButton.heightAnchor.constraint(equalToConstant: 56),
            subAddresssTextField.heightAnchor.constraint(equalToConstant: 48),

            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        [searchAddressButton, researchAddressButton]
            .forEach {
                $0.addTarget(self, action: #selector(onTap(_:)), for: .touchUpInside)
            }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func onTap(_ handler: UIButton) {
#if os(iOS)
        let rootViewController = UIApplication.shared.keyWindow!.rootViewController!
#endif
        let kPostal = KPostalViewController()
        kPostal.completeHandler = onData
        rootViewController.present(kPostal, animated: true)
    }

    func onData(_ data: [String: Any]?) {
        if let data,
           let lotNumberAdress = data["jibunAddress"] as? String,
           let roadAddress = data["roadAddress"] as? String,
           let lat = data["kakaoLat"] as? String,
           let lng = data["kakaoLng"] as? String {
            roadAddressLabel.text = roadAddress
            lotNumberAddressLabel.text = "[지번] \(lotNumberAdress)"
            addressStack.isHidden = true
            subAddressStack.isHidden = false
            onChange?(lat, lng, roadAddress)
        }
    }
}
