//
//  AnnounceDetailViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 7/23/24.
//

import Foundation
import RxSwift
import RxCocoa

final class AnnounceDetailViewModel: ViewModel {
    struct Input {
        let isMustRead: Driver<Bool>
        let title: Driver<String>
        let content: Driver<String>
        let saveAnnounce: Signal<()>
    }
    
    struct Output {
        let item: Driver<AnnounceDetailItem>
        let saveEnabled: Driver<Bool>
    }
    
    private let coordinator: MainFlowCoordinator
    private let noticeUseCase: NoticeUseCase
    private let announceId: Announce.ID
    
    init(
        dependencies: (
            coordinator: MainFlowCoordinator,
            noticeUseCase: NoticeUseCase,
            announceId: Announce.ID
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.noticeUseCase = dependencies.noticeUseCase
        self.announceId = dependencies.announceId
    }
    
    @MainActor
    func transform(_ input: Input) -> Output {
        let indicator = ActivityIndicator()
        let isLoading = indicator.asDriver()
        
        let item = noticeUseCase.fetchAnnounceDetail(announceId: announceId)
            .trackActivity(indicator)
            .map { AnnounceDetailItem.init($0) }
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
        
        let isUpdated = input.saveAnnounce.withLatestFrom(request)
            .flatMapLatest { [unowned self] request -> Driver<Bool> in
                noticeUseCase.updateNotice(noticeIdentifier: announceId, with: request)
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
            saveEnabled: updateEnabled
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
