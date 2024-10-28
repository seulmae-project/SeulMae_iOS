//
//  WorkControlModalViewController.swift
//  SeulMae
//
//  Created by 조기열 on 7/22/24.
//

import UIKit

final class WorkControlModalViewController: UIViewController {
    
    private let workStatusView: WorkStatusView = WorkStatusView()
    
    private let workStartButton = UIButton.common(title: AppText.workStart)
    
    private let addWorkLogButton = UIButton.common(title: AppText.addWorkLog)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHierarchy()
    }
    
    func bindSubviews() {
//    workStart: workStartButton.rx.tap.asSignal(),
//    addWorkLog: addWorkLogButton.rx.tap.asSignal()
    }
    
    func setHierarchy() {
        view.backgroundColor = .systemBackground
        
        let workButtonHStack = UIStackView(arrangedSubviews: [
            workStartButton,
            addWorkLogButton
        ])
        workButtonHStack.spacing = 12
        workButtonHStack.distribution = .fillEqually
        
        workStatusView.label.text = "남은시간"
        workStatusView.label3.text = "-월 합계 -원"
        workStatusView.label4.text = "-원"
        workStatusView.progressView.progress = 0.5
        
        
        let modalVStack = UIStackView(arrangedSubviews: [
            workStatusView,
            workButtonHStack
        ])
        modalVStack.axis = .vertical
        modalVStack.spacing = 16
        
        workButtonHStack.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        modalVStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalTo(view.snp_bottomMargin).inset(16)
            make.centerX.equalToSuperview()
        }
    }
}
