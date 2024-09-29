//
//  File.swift
//  SeulMae
//
//  Created by 조기열 on 8/16/24.
//

import RxSwift
import RxCocoa
import AuthenticationServices

extension ASAuthorizationController: HasDelegate {
    public typealias Delegate = ASAuthorizationControllerDelegate
}

open class RxASAuthorizationControllerDelegateProxy: DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate>, DelegateProxyType {
    public weak private(set) var authorizationController: ASAuthorizationController?

    public init(authorizationController: ParentObject) {
        self.authorizationController = authorizationController
        super.init(parentObject: authorizationController, delegateProxy: RxASAuthorizationControllerDelegateProxy.self)
    }

    public static func registerKnownImplementations() {
        self.register { RxASAuthorizationControllerDelegateProxy(authorizationController: $0) }
    }
    
    private var _credentialPublishSubject: PublishSubject<ASAuthorizationAppleIDCredential>?
    
    internal var credentialPublishSubject: PublishSubject<ASAuthorizationAppleIDCredential> {
        if let subject = _credentialPublishSubject {
            return subject
        }

        let subject = PublishSubject<ASAuthorizationAppleIDCredential>()
        _credentialPublishSubject = subject

        return subject
    }
    
    deinit {
        if let subject = _credentialPublishSubject {
            subject.on(.completed)
        }
    }
}

extension RxASAuthorizationControllerDelegateProxy: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
      switch authorization.credential {
      case let appleIDCredential as ASAuthorizationAppleIDCredential:
          if let subject = self._credentialPublishSubject {
              subject.on(.next(appleIDCredential))
          }
      default:
        break
      }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        Swift.print(#fileID, "error: \(error)")
    }
}
