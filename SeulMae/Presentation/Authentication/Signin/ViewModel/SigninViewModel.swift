//
//  SigninViewModel.swift
//  SeulMae
//
//  Created by 조기열 on 6/12/24.
//

import RxSwift
import RxCocoa

final class SigninViewModel: ViewModel {
    
    struct Input {
        let email: Driver<String>
        let password: Driver<String>
        let signin: Signal<()>
        let kakaoSignin: Signal<()>
        let signup: Signal<()>
        let acountRecovery: Signal<()>
    }
    
    struct Output {
        
    }
    
    private let validationService: ValidationService
    
    init(validationService: ValidationService) {
        self.validationService = validationService
    }
        
    func transform(_ input: Input) -> Output {
        
        
        return Output()
    }
    
}
