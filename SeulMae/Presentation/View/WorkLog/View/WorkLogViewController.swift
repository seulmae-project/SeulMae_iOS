//
//  WorkLogViewController.swift
//  SeulMae
//
//  Created by 조기열 on 9/22/24.
//

import UIKit
import RxSwift
import RxCocoa

final class WorkLogViewController: BaseViewController {
    
    // MARK: - UI
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.refreshControl = refreshControl
        return scrollView
    }()
    
    private let titleLabel: UILabel = .title(title: "기록한 정보를 확인해주세요 \nOR 근무 등록")
    private let workLogSummeryView = WorkLogSummaryView()
    private let _workStartDateLabel: UILabel = .common(title: "시작 시간", size: 15)
    private let workStartDatePicker: UIDatePicker = Ext.dateAndTime
    private let _workEndDateLabel: UILabel = .common(title: "종료 시간", size: 15)
    private let workEndDatePicker: UIDatePicker = Ext.dateAndTime
    private let _messageLable: UILabel = .common(title: "전달사항", size: 15)
    private let messageTextView: UITextView = Ext.common(placeholder: "전달사항을 입력해주세요")
    private let _memoLable: UILabel = .common(title: "메모", size: 15)
    private let memoTextView: UITextView = Ext.common(placeholder: "메모를 입력해주세요")
    private let requestAttendanceButton: UIButton = .common(title: "저장")
    
    // MARK: - Properties
    
    private let coordinator: HomeFlowCoordinator
    private let workplaceUseCase: WorkplaceUseCase
    private let attendanceUseCase: AttendanceUseCase

    
    // MARK: - Life Cycle Methods
    
    init(
        coordinator: HomeFlowCoordinator,
        workplaceUseCase: WorkplaceUseCase,
        attendanceUseCase: AttendanceUseCase
    ) {
        self.coordinator = coordinator
        self.workplaceUseCase = workplaceUseCase
        self.attendanceUseCase = attendanceUseCase
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let startStack = UIStackView()
        startStack.alignment = .center
        startStack.distribution = .equalCentering
        [_workStartDateLabel, workStartDatePicker]
            .forEach(startStack.addArrangedSubview(_:))
        
        let endStack = UIStackView()
        endStack.alignment = .center
        endStack.distribution = .equalCentering
        [_workEndDateLabel, workEndDatePicker]
            .forEach(endStack.addArrangedSubview(_:))
        
        let messageStack = UIStackView()
        messageStack.axis = .vertical
        messageStack.spacing = 9.5
        messageStack.distribution = .equalCentering
        [_messageLable, messageTextView]
            .forEach(messageStack.addArrangedSubview(_:))
        
        let memoStack = UIStackView()
        memoStack.axis = .vertical
        memoStack.spacing = 9.5
        memoStack.distribution = .equalCentering
        [_memoLable, memoTextView]
            .forEach(memoStack.addArrangedSubview(_:))
        
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 20
        [titleLabel, workLogSummeryView, startStack, endStack, messageStack, memoStack, requestAttendanceButton]
            .forEach(contentStack.addArrangedSubview(_:))
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        let inset = CGFloat(20)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            contentStack.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            workEndDatePicker.widthAnchor.constraint(equalToConstant: 200),
            workStartDatePicker.widthAnchor.constraint(equalToConstant: 200),
            
            workLogSummeryView.heightAnchor.constraint(equalToConstant: 70),
            
            messageTextView.heightAnchor.constraint(equalToConstant: 100),
            memoTextView.heightAnchor.constraint(equalToConstant: 100),
            
            requestAttendanceButton.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        let onLoad = rx.methodInvoked(#selector(viewWillAppear(_:)))
            .map { _ in return () }
            .asSignal()
        
        let onRefresh = refreshControl.rx
            .controlEvent(.valueChanged)
            .map { _ in }
            .asSignal()
        
        // handle refresh loading
        Task {
            for await _ in onRefresh.values {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                refreshControl.endRefreshing()
            }
        }
        
        let tracker = ActivityIndicator()
        let loading = tracker.asDriver()
        
        let _onLoad = Signal.merge(.just(()), onLoad, onRefresh)
        let baseWage = _onLoad.withUnretained(self)
            .flatMapLatest { (self, _) -> Driver<Int> in
                return self.workplaceUseCase.fetchMyInfo()
                    .map(\.baseWage)
                    .asDriver()
            }
        
        let startDate = workStartDatePicker.rx.date.asDriver()
        let endDate = workEndDatePicker.rx.date.asDriver()
        let message = messageTextView.rx.text.orEmpty.asDriver()
        let memo = memoTextView.rx.text.orEmpty.asDriver()
        
        let onSave = requestAttendanceButton.rx.tap.asSignal()
        
        let startAndEnd = Driver.combineLatest(
            startDate, endDate) { (start: $0, end: $1) }
        
        let validatedStartAndEnd = startAndEnd.map { pair -> ValidationResult in
            if pair.start < pair.end {
                return .ok(message: "")
            } else {
                return .failed(message: "종료일이 시작일보다 빠를 수 없어요")
            }
        }
        
        let saveEnabled = Driver.combineLatest(
            validatedStartAndEnd, loading) { startAndEnd, loading in
                startAndEnd.isValid &&
                !loading
            }
            .distinctUntilChanged()
        
        let workLog = Driver.combineLatest(
            startDate, endDate, message, memo, baseWage
        ) { startDate, endDate, message, memo, baseWage in
            return AttendanceService.calculate(
                start: startDate, end: endDate, wage: baseWage)
        }
        
        let isSaved = onSave
            .withLatestFrom(workLog)
            .withUnretained(self)
            .flatMapLatest { (self, workLog) -> Driver<Bool> in
                return self.attendanceUseCase
                    .attend(request: workLog)
                    .trackActivity(tracker)
                    .asDriver()
            }
        
        Task {
            for await _ in isSaved.values {
                coordinator.goBack()
            }
        }
        
        Task {
            for await isEnabled in saveEnabled.values {
                requestAttendanceButton.ext.setEnabled(isEnabled)
            }
        }
        
        loading.drive(self.loading)
            .disposed(by: disposeBag)
    }
}
