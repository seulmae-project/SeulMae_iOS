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
        let isMale: Signal<Bool>
        let username: Driver<String>
        let birthday: Driver<String>
        let nextStep: Signal<()>
    }
    
    struct Output {
        let loading: Driver<Bool>
        let validatedUsername: Driver<ValidationResult>
        let validatedBirthday: Driver<ValidationResult>
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
        let indicator = ActivityIndicator()
        let loading = indicator.asDriver()
        
        let validatedImage = input.image.asDriver()
        
        let validatedName = input.username
            .flatMapLatest { [weak self] username -> Driver<ValidationResult> in
                guard let strongSelf = self else { return .empty() }
                return strongSelf.validationService
                    .validateUsername(username)
                    .asDriver()
            }
    
        let validatedBirthday = input.birthday
            .flatMapLatest { [weak self] birthday -> Driver<ValidationResult> in
                guard let strongSelf = self else { return .empty() }
                return strongSelf.validationService
                    .validateBirthday(birthday)
                    .asDriver()
            }
        
        let request = Driver.combineLatest(validatedImage, input.isMale.asDriver(), input.username, input.birthday) {
            Swift.print("data: \($0), isMale: \($1), name: \($2), birthday: \($3)")
            return (data: $0, isMale: $1, name: $2, birthday: $3)
        }
        
        let nextStepEnabled = Driver.combineLatest(
            validatedName, validatedBirthday, loading) { name, birthday, signingUp in
                name.isValid &&
                birthday.isValid &&
                !signingUp
            }
            .distinctUntilChanged()
      
        let signedUp = input.nextStep.withLatestFrom(request)
            .flatMapLatest { [weak self] data, gender, name, birthday -> Driver<Bool> in
                guard let strongSelf = self else { return .empty() }
                strongSelf.request
                    .updateProfile(name: name, isMale: gender, birthday: birthday)
                Swift.print("request: \(strongSelf.request)")
                return strongSelf.authUseCase
                    .signup(request: strongSelf.request, file: data)
                    .trackActivity(indicator)
                    .asDriver(onErrorJustReturn: false)
            }
        
        let signedUpAndUsername = Driver.combineLatest(signedUp, input.username) { (signedup: $0, username: $1) }

        // MARK: Flow Logic
        
        Task {
            for await (signedUp, username) in signedUpAndUsername.values {
                coordinator.showCompletion(item: .signup(signedUp: signedUp, username: username))
            }
        }
        
        // MARK: Output
        
        return Output(
            loading: loading,
            validatedUsername: validatedName,
            validatedBirthday: validatedBirthday,
            nextStepEnabled: nextStepEnabled
        )
    }
}
