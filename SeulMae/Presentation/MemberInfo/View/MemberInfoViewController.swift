//
//  MemberInfoViewController.swift
//  SeulMae
//
//  Created by 조기열 on 7/19/24.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class MemberInfoViewController: UIViewController {
    
    // MARK: - Flow Methods
    
    static func create(viewModel: MemberViewModel) -> MemberInfoViewController {
        let view = MemberInfoViewController()
        view.viewModel = viewModel
        return view
    }
    
    // MARK: - Public UI Properties
    
    /// 프로필 사진
    private let memberImageView = UIImageView()
    
    /// 이름
    private let nameLabel = UILabel()
    
    /// 가입일
    private let joinDateLabel = UILabel()
    
    /// 연락처
    private let contactLabel = UILabel()
    
    /// 근무 일정
    private let scheduleListView = UIView()
    
    // MARK: - Personal UI Properties
    
    /// 시급
    private let wageLabel = UILabel()
    
    /// 근무 이력 섹션 타이틀
    private let workLogSectionTitle = UILabel.title(title: "이번달\n-- 을 확인해 보세요")
    
    /// 기간 선택
    private let dateRangePickerView = UIView()
    
    /// 근무 요약 정보
    private let workLogSummaryView = UIView()
    
    /// 근무 이력 리스트
    private let workLogListView = UIView()
    
    // MARK: - Properties
    
    
    
    
    // MARK: - Dependencies
    
    private var viewModel: MemberViewModel!
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // onNavItem()
        onBind()
    }
    
    // MARK: - Nav Item
    
    private func configureNavItem() {
        navigationItem.title = ""
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    // MARK: - Data Binding
    
    private func onBind() {
        
        let onLoad = rx.methodInvoked(#selector(viewWillAppear))
            .map { _ in }
            .asSignal()
        
        let output = viewModel.transform(
            .init(
                onLoad: onLoad
//                onContactTap: ,
//                onDateRangeSelected: ,
//                onScheduleTap: ,
//                onWorkLogTap:
            )
        )
        
        Task {
            for await memberInfo in output.memberInfo.values {
                // TODO: memberInfo -> item 변환하여 필수 정보가 없을 시 error
                if  let urlStr = memberInfo.imageURL,
                    let imageURL = URL(string: urlStr) {
                    memberImageView.kf.setImage(with: imageURL, options: [
                        .onFailureImage(UIImage(systemName: "circle.fill"))
                    ])
                }
                nameLabel.text = memberInfo.name
                joinDateLabel.text = memberInfo.joinDate?.description
                contactLabel.text = memberInfo.phoneNumber
                // scheduleListView.items = memberInfo.sch
                //
            }
        }
        
//        Task {
//            for await workLogList in output.workLogList.values {
//                workLogListView = workLogList
//            }
//        }
    }
    
    
    // MARK: - Hierarchy
    
}

