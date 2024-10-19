//
//  JoinApplicationViewController.swift
//  SeulMae
//
//  Created by 조기열 on 10/4/24.
//

import UIKit
import RxSwift
import RxCocoa

final class JoinApplicationViewController: BaseViewController {
    
    private let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        return control
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.refreshControl = refreshControl
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let margins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        scrollView.directionalLayoutMargins = margins
        return scrollView
    }()
    
    private let _titleLabel: UILabel = .common(title: "")
    private let userImageView: UIImageView = {
       let imageView = UIImageView()
        
        return imageView
    }()
    private let _wageLabel: UILabel = .common(title: "")
    private let wageTextField: UITextField = .common(placeholder: "")
    private let _paydayLabel: UILabel = .common(title: "")
    private let paydayTextField: UITextField = .common(placeholder: "")
    private let _scheduleLabel: UILabel = .common(title: "")
    private let showScheduleListButton: UIButton = .common(title: "")
    
    private let okButton: UIButton = .half(title: "OK")
    private let noButton: UIButton = .half(title: "NO")
    
    private let coordinator: TabBarFlowCoordinator
    private let workplaceUseCase: WorkplaceUseCase
    private let validationService: ValidationService
    private let appNoti: Reminder
    
    init(coordinator: TabBarFlowCoordinator, 
         appNoti: Reminder,
         workplaceUseCase: WorkplaceUseCase,
         validationService: ValidationService
    ) {
        self.coordinator = coordinator
        self.workplaceUseCase = workplaceUseCase
        self.validationService = validationService
        self.appNoti = appNoti
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        bindSubviews()
    }
    
    func bindSubviews() {
        let indicator = ActivityIndicator()
        let loading = indicator.asDriver()
        
        let wage = wageTextField.rx.text.orEmpty.asDriver()
        let payday = paydayTextField.rx.text.orEmpty.asDriver()
        
        let validateWage = wage
            .flatMapLatest(validationService.validateWage)
        let validatedPayday = payday
            .flatMapLatest(validationService.validatePayday)
        
        let enabled = Driver.combineLatest(
            validateWage, validatedPayday, loading) { wage, payday, loading in
                wage.isValid &&
                payday.isValid &&
                !loading
            }
            .distinctUntilChanged()

        let wageAndPayday = Driver.combineLatest(
            wage, payday) { (wage: $0, payday: $1) }
        
        let ok = okButton.rx.tap.asDriver()
        let no = noButton.rx.tap.asDriver()
        
        let okr = ok.withLatestFrom(wageAndPayday)
            .flatMapLatest { [weak self] pair -> Driver<Bool> in
            guard let strongSelf = self else { return .empty() }
            return strongSelf.workplaceUseCase
                    .acceptApplication(
                        workplaceApproveId: 0,
                        initialUserInfo: InitialUserInfo(
                            workplaceScheduleId: 0,
                            payday: 0,// pair.payday,
                            baseWage: 0, // pair.wage,
                            memo: ""
                        ))
                // .track
                .asDriver()
        }
        
        let nor = no.flatMapLatest { [weak self] _ -> Driver<Bool> in
            guard let strongSelf = self else { return .empty() }
            return strongSelf.workplaceUseCase
                // .track
                .denyApplication(workplaceApproveId: 0)
                .asDriver()
        }
        
        // MARK: - Coordinator Methods
        
        let aa = Driver.merge(ok, no)
        Task {
            for await _ in aa.values {
                coordinator.goBack()
            }
        }
        
        let showScheduleList = showScheduleListButton.rx.tap.asDriver()
        Task {
            for await _ in showScheduleList.values {
                // coordinator.showScheduleList()
            }
        }
    }
    
    func setupConstraints() {
        view.addSubview(scrollView)
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
    }
}
