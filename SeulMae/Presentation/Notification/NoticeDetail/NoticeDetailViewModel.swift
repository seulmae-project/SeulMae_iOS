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
        let item = noticeUseCase.fetchNoticeDetail(noticeIdentifier: noticeIdentifier)
            .map { NoticeDetailItem.init($0) }
            .asDriver()
        
        let validatedTitle = input.title
            .map { title -> ValidationResult in
                if title.isEmpty {
                    // TODO: - 공백 제거 후 확인하도록 변경
                    return .empty
                } 
                // title 글자수 제한 없으면
                return .ok(message: "ok")
            }
        
        let validatedContent = input.title
            .map { title -> ValidationResult in
                if title.isEmpty {
                    // TODO: - 공백 제거 후 확인하도록 변경
                    return .empty
                }
                // title 글자수 제한 없으면
                return .ok(message: "ok")
            }
        
        let inputs = Driver.combineLatest(
            input.isMustRead, input.title, input.content
        ) {
            (isMustRead: $0, title: $1, content: $2)
        }
        
        
        
        
        
        
        
        
        let request = Driver.combineLatest(
            input.isMustRead,
            input.title,
            input.content
        ) {
            isMustRead, title, content in
            return UpdateNoticeRequest(
                title: title,
                content: content,
                isImportant: isMustRead
            )
        }
        
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
            item: item
        )
    }
}
