//
//  NotiListViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 7/22/24.
//

import Foundation
import RxSwift
import RxCocoa

final class NotiListViewModel: ViewModel {
    struct Input {
        let onItemTap: Signal<NotiListItem>
    }
    
    struct Output {
        let categories: Driver<[NotiListItem]>
        let notiList: Driver<[NotiListItem]>
    }
    
    // MARK: - Dependency
    
    private let coordinator: HomeFlowCoordinator
    private let noticeUseCase: NoticeUseCase
        
    // MARK: - Life Cycle
    
    init(
        dependency: (
            coordinator: HomeFlowCoordinator,
            noticeUseCase: NoticeUseCase
        )
    ) {
        self.coordinator = dependency.coordinator
        self.noticeUseCase = dependency.noticeUseCase
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        
        let indicator = ActivityIndicator()
        let loading = indicator.asDriver()
        
        let categories = Driver.just(["JOIN_REQUEST", "some"])
            .map { $0.map(NotiListItem.init(cateogry:)) }
        
        // TODO: workplace도 userUseCase에서 가저오기
//        let notiList = noticeUseCase
//            .fetchAppNotificationList(workplaceId: workplaceIdentifier)
//            .map { $0.map(NotiListItem.init(noti:)) }
//            .asDriver()
       
        // MARK: Coordinator Logic
        
        Task {
            for await item in input.onItemTap.values {
                if case .category = item.type,
                   let category = item.category {
                    Swift.print("Did tap noti category: \(category)")
                }
                
                if case .noti = item.type,
                   let notiId = item.noti?.id {
                    // TODO: 화면 이동 로직 고민..?
                    // category 리스트에 따라? 고민해보자 혹은 url 식으로 연결
                    Swift.print("Did tap noti: \(notiId)")
                }
            }
        }

        return Output(
            categories: categories,
            notiList: .empty()
        )
    }
}
