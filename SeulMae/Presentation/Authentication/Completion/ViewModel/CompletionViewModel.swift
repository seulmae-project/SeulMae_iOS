//
//  CompletionViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 6/11/24.
//

import UIKit
import RxSwift
import RxCocoa

final class CompletionViewModel: ViewModel {
    struct Input {
        let onDone: Signal<()>
    }
    
    struct Output {
        let title: Driver<String>
    }
    
    private let coordinator: AuthFlowCoordinator
    private let type: CompletionType

    init(
        dependencies: (
            coordinator: AuthFlowCoordinator,
            type: CompletionType
        )
    ) {
        self.coordinator = dependencies.coordinator
        self.type = dependencies.type
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        Task {
            for await _ in input.onDone.values {
                coordinator.showSignin()
            }
        }
        
        return .init(
            title: .just(type.title)
        )
    }
}
