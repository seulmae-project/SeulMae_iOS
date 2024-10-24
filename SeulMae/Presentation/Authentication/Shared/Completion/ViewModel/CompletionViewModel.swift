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
        let nextStep: Signal<()>
    }
    
    struct Output {
        let item: Driver<CompletionItem>
    }
    
    private let coordinator: AuthFlowCoordinator
    private let item: CompletionItem
    
    init(
        dependency: (
            coordinator: AuthFlowCoordinator,
            item: CompletionItem
        )
    ) {
        self.coordinator = dependency.coordinator
        self.item = dependency.item
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        Task {
            for await _ in input.nextStep.values {
                coordinator.showSingin()
            }
        }
        
        return Output(item: .just(item))
    }
}
