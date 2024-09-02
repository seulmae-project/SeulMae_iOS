//
//  AnnounceViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 8/31/24.
//

import Foundation
import RxSwift
import RxCocoa

final class AnnounceListViewModel: ViewModel {
    struct Input {
        
    }
    
    struct Output {
        let isLoading: Driver<Bool>
        let items: Driver<[AnnounceListItem]>
        
    }
    
    private let noticeUseCase: NoticeUseCase
    
    init(
        noticeUseCase: NoticeUseCase
    ) {
        self.noticeUseCase = noticeUseCase
    }
    
    @MainActor
    func transform(_ input: Input) -> Output {
        let indicator = ActivityIndicator()
        let isLoading = indicator.asDriver()
        
        let items = noticeUseCase.fetchAnnounceList(page: 0, size: 30)
            .map { $0.map(AnnounceListItem.init(announce:)) }
            .asDriver()
        
        return Output(
            isLoading: isLoading,
            items: items
        )
    }
}
