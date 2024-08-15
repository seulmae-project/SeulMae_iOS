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
    
    private var _credentialPublishSubject: PublishSubject<AppleAccountCredential>?
    
    internal var credentialPublishSubject: PublishSubject<AppleAccountCredential> {
        if let subject = _credentialPublishSubject {
            return subject
        }

        let subject = PublishSubject<AppleAccountCredential>()
        _credentialPublishSubject = subject

        return subject
    }
    
    deinit {
        if let subject = _credentialPublishSubject {
            subject.on(.completed)
        }
    }
}

public struct AppleAccountCredential {
    
}

extension RxASAuthorizationControllerDelegateProxy: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
      switch authorization.credential {
      case let appleIDCredential as ASAuthorizationAppleIDCredential:
          Swift.print(#line, appleIDCredential.user)
          Swift.print(#line, appleIDCredential.fullName)
          Swift.print(#line, appleIDCredential.email)
          Swift.print(#line, String(data: appleIDCredential.identityToken!, encoding: .utf8)!)
          Swift.print(#line, String(data: appleIDCredential.authorizationCode!, encoding: .utf8)!)
          
          if let subject = self._credentialPublishSubject {
              subject.on(.next(AppleAccountCredential()))
          }
      case let passwordCredential as ASPasswordCredential:
          if let subject = self._credentialPublishSubject {
              subject.on(.next(AppleAccountCredential()))
          }
          
          Swift.print(#line, passwordCredential.user)
          Swift.print(#line, passwordCredential.password)
      default:
        break
      }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        Swift.print(#fileID, "error: \(error)")
    }
}
