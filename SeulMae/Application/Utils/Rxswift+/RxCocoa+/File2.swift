//
//  File2.swift
//  SeulMae
//
//  Created by 조기열 on 8/16/24.
//

import RxSwift
import RxCocoa
import AuthenticationServices

extension Reactive where Base: ASAuthorizationController {
    public var delegate: DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate> {
        return RxASAuthorizationControllerDelegateProxy.proxy(for: base)
    }
    
    public var credential: ControlEvent<AppleAccountCredential> {
        let source = RxASAuthorizationControllerDelegateProxy.proxy(for: base).credentialPublishSubject
        return ControlEvent(events: source)
    }
}
