//
//  ProfileSetupViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 6/11/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileSetupViewModel: ViewModel {
    struct Input {
        let image: Signal<Data>
        let gender: Signal<Int>
        let username: Driver<String>
        let year: Signal<Int>
        let month: Signal<Int>
        let day: Signal<Int>
        let nextStep: Signal<()>
    }
    
    struct Output {
        let validatedUsername: Driver<ValidationResult>
        let signingUp: Driver<Bool>
        let nextStepEnabled: Driver<Bool>
    }
    
    // MARK: - Dependency
    
    private let coordinator: AuthFlowCoordinator
    
    private let authUseCase: AuthUseCase
    
    private let validationService: ValidationService
    
    private let wireframe: Wireframe
    
    private var request: SignupRequest
    
    // MARK: - Life Cycle
    
    init(
        dependency: (
            coordinator: AuthFlowCoordinator,
            authUseCase: AuthUseCase,
            validationService: ValidationService,
            wireframe: Wireframe,
            request: SignupRequest
        )
    ) {
        self.coordinator = dependency.coordinator
        self.authUseCase = dependency.authUseCase
        self.validationService = dependency.validationService
        self.wireframe = dependency.wireframe
        self.request = dependency.request
    }
    
    @MainActor func transform(_ input: Input) -> Output {
        
        // TODO: image valdiation - size
        
        let validatedImage = input.image.asDriver()
        
        let gender = input.gender
            .map { $0 == 0 }
            .distinctUntilChanged()
            .asDriver()
        
        let validatedName = input.username
            .flatMapLatest { [weak self] username -> Driver<ValidationResult> in
                guard let strongSelf = self else { return .empty() }
                return strongSelf.validationService
                    .validateUsername(username)
                    .asDriver()
            }
        
        let birthday = Signal.combineLatest(input.year, input.month, input.day) { year, month, day in
            return "\(year)\(month)\(day)"
        }
            .asDriver()
        
        let request = Driver.combineLatest(validatedImage, gender, input.username, birthday)
        
        let indicator = ActivityIndicator()
        let signingUp = indicator.asDriver()
        
        let signedUp = input.nextStep.asObservable()
            .withLatestFrom(request)
            .flatMapLatest { [weak self] data, gender, name, birthday -> Driver<Bool> in
                guard let strongSelf = self else { return .empty() }
                strongSelf.request.setProfile(name: name, imageData: data, isMale: gender, birthday: birthday)
                return strongSelf.authUseCase.signup(strongSelf.request)
                    .trackActivity(indicator)
                    .asDriver(onErrorJustReturn: false)
            }
            .startWith(false)
        
        // MARK: Flow Logic
        
        let nextStepEnabled = Driver.combineLatest(
            validatedName, signingUp) { name, signingUp in
                name.isValid &&
                !signingUp
            }
            .distinctUntilChanged()
        
        Task {
            for await _ in input.nextStep.values {
                // coordinator.showSignupCompletion()
            }
        }
        
        return Output(
            validatedUsername: validatedName,
            signingUp: signingUp,
            nextStepEnabled: nextStepEnabled
        )
    }
}
