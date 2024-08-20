//
//  NoticeDetailViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 7/23/24.
//

import Foundation
import RxSwift
import RxCocoa

final class NoticeDetailViewModel: ViewModel {
    struct Input {
        let isMustRead: Driver<Bool>
        let title: Driver<String>
        let content: Driver<String>
        let onUpdate: Signal<()>
    }
    
    struct Output {
        let item: Driver<NoticeDetailItem>
        let updateEnabled: Driver<Bool>
    }
    
    private let noticeIdentifier: Notice.ID
    
    private let coordinator: MainFlowCoordinator
    
    private let noticeUseCase: NoticeUseCase
    
    init(
        dependencies: (
            noticeIdentifier: Notice.ID,
            coordinator: MainFlowCoordinator,
            noticeUseCase: NoticeUseCase
        )
    ) {
        self.noticeIdentifier = dependencies.noticeIdentifier
        self.coordinator = dependencies.coordinator
        self.noticeUseCase = dependencies.noticeUseCase
    }
    
    @MainActor
    func transform(_ input: Input) -> Output {
        let indicator = ActivityIndicator()
        let isLoading = indicator.asDriver()
        
        // MARK: - Item For View
        
        let item = noticeUseCase.fetchNoticeDetail(noticeIdentifier: noticeIdentifier)
            .map { NoticeDetailItem.init($0) }
            .asDriver()
        
        // MARK: - Validation For Update
        
        let validatedTitle = input.title
            .map(validateText(_:))
        
        let validatedContent = input.title
            .map(validateText(_:))
        
        let updateEnabled = Driver.combineLatest(
            validatedTitle,
            validatedContent,
            isLoading) { (title, content, isLoading) in
                title.isValid &&
                content.isValid &&
                !isLoading
            }
            .distinctUntilChanged()
        
        // MARK: - Update Request
        
        let request = Driver.combineLatest(
            input.isMustRead, 
            input.title,
            input.content) {
                isMustRead, title, content in
                return UpdateNoticeRequest(
                    title: title,
                    content: content,
                    isImportant: isMustRead
                )
            }
            .distinctUntilChanged()
        
        let isUpdated = input.onUpdate.withLatestFrom(request)
            .flatMapLatest { [unowned self] request -> Driver<Bool> in
                noticeUseCase.updateNotice(noticeIdentifier: noticeIdentifier, with: request)
                    .asDriver()
            }
        
        Task {
            for await isUpdated in isUpdated.values {
                // TODO: - 얼럿으로 수정 후 화면 닫기?
                Swift.print("☀️☀️☀️ 공지 업데이트 성공 ☀️☀️☀️")
                coordinator.goBack()
            }
        }
        
        return Output(
            item: item,
            updateEnabled: updateEnabled
        )
    }
    
    func validateText(_ text: String) -> ValidationResult {
        if text.isEmpty {
            // TODO: - 공백 제거 후 확인하도록 변경
            return .empty(message: "")
        }
        // title 글자수 제한 없으면
        return .ok(message: "ok")
    }
}
