//
//  IDRecoveryViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 6/12/24.
//

import Foundation

final class IDRecoveryViewModel: ViewModel {
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    // MARK: - Dependency
    
    private let coordinator: AuthFlowCoordinator
    
    private let authUseCase: AuthUseCase
    
    private let validationService: ValidationService
    
    private let wireframe: Wireframe
    
    // MARK: - Life Cycle
    
    init(
        dependency: (
            coordinator: AuthFlowCoordinator,
            authUseCase: AuthUseCase,
            validationService: ValidationService,
            wireframe: Wireframe
        )
    ) {
        self.coordinator = dependency.coordinator
        self.authUseCase = dependency.authUseCase
        self.validationService = dependency.validationService
        self.wireframe = dependency.wireframe
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        
        return Output()
    }
}
