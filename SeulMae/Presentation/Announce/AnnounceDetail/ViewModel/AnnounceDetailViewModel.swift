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
        let isLoading: Driver<Bool>
        let item: Driver<AnnounceDetailItem>
        let saveEnabled: Driver<Bool>
    }
    
    private let coordinator: MainFlowCoordinator
    private let noticeUseCase: NoticeUseCase
    private let wireframe: Wireframe
    private let announceId: Announce.ID?
    
    init(
        dependencies: (
            coordinator: MainFlowCoordinator,
            noticeUseCase: NoticeUseCase,
            wireframe: Wireframe,
            announceId: Announce.ID?
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.noticeUseCase = dependencies.noticeUseCase
        self.wireframe = dependencies.wireframe
        self.announceId = dependencies.announceId
    }
    
    @MainActor
    func transform(_ input: Input) -> Output {
        let indicator = ActivityIndicator()
        let isLoading = indicator.asDriver()
        
        let item: Driver<AnnounceDetailItem>
        if let announceId {
            item = noticeUseCase.fetchAnnounceDetail(announceId: announceId)
                .trackActivity(indicator)
                .map { AnnounceDetailItem.init($0) }
                .asDriver()
        } else {
            item = .empty()
        }
        
        // MARK: - Input Validation
        
        let validatedTitle = input.title
            .map(validateText(_:))
        
        let validatedContent = input.title
            .map(validateText(_:))
        
        let saveEnabled = Driver.combineLatest(
            validatedTitle,
            validatedContent,
            isLoading) { (title, content, isLoading) in
                title.isValid &&
                content.isValid &&
                !isLoading
            }
            .distinctUntilChanged()
        
        // MARK: - Request
        
        let request = Driver.combineLatest(
            input.isMustRead,
            input.title,
            input.content) { isMustRead, title, content in
                return (
                    title: title,
                    content: content,
                    isImportant: isMustRead)
            }
            // .distinctUntilChanged()
        
        let isSaved = input.saveAnnounce.withLatestFrom(request)
            .flatMapLatest { [unowned self] input -> Driver<Bool> in
                return noticeUseCase.saveAnnounce(announceId: announceId, title: input.title, content: input.content, isImportant: input.isImportant)
                    .trackActivity(indicator)
                    .asDriver()
            }
            .flatMapLatest { [unowned self] isSaved -> Driver<Bool> in
                let message = isSaved ? "저장되었습니다" : "알 수 없는 문제가 발생했습니다\n다음에 다시 시도해 주세요"
                return wireframe.promptFor(message, cancelAction: "OK", actions: [])
                    .map { _ in isSaved }
                    .asDriver(onErrorJustReturn: false)
            }

        
        Task {
            for await isSaved in isSaved.values {
                coordinator.goBack()
            }
        }
        
        return Output(
            isLoading: isLoading,
            item: item,
            saveEnabled: saveEnabled
        )
    }
    
    private func validateText(_ text: String) -> ValidationResult {
        if text.isEmpty {
            // TODO: - 공백 제거 후 확인하도록 변경
            return .empty(message: "")
        }
        // title 글자수 제한 없으면
        return .ok(message: "ok")
    }
}
