//
//  Wireframe.swift
//  SeulMae
//
//  Created by 조기열 on 6/17/24.
//

import UIKit
import RxSwift

protocol Wireframe {
    func open(url: URL)
    func promptFor<Action: CustomStringConvertible>(_ message: String, cancelAction: Action, actions: [Action]) -> Observable<Action>
    func promptAlert<Action: CustomStringConvertible>(_ title: String, message: String, actions: [Action]) -> Observable<Action>
    func searchAddress() -> Single<[String: Any]>
}

class DefaultWireframe: Wireframe {
    static let shared = DefaultWireframe()

    func open(url: URL) {
        #if os(iOS)
            UIApplication.shared.open(url)
        #elseif os(macOS)
            NSWorkspace.shared.open(url)
        #endif
    }

    #if os(iOS)
    private static func rootViewController() -> UIViewController {
        // cheating, I know
        return UIApplication.shared.keyWindow!.rootViewController!
    }
    #endif
    
//    func showToast(_ message : String, withDuration: Double, delay: Double) {
//        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
//        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
//        toastLabel.textColor = UIColor.white
//        toastLabel.font = UIFont.systemFont(ofSize: 14.0)
//        toastLabel.textAlignment = .center
//        toastLabel.text = message
//        toastLabel.alpha = 1.0
//        toastLabel.layer.cornerRadius = 16
//        toastLabel.clipsToBounds  =  true
//            
//        self.view.addSubview(toastLabel)
//            
//        UIView.animate(withDuration: withDuration, delay: delay, options: .curveEaseOut, animations: {
//            toastLabel.alpha = 0.0
//        }, completion: {(isCompleted) in
//            toastLabel.removeFromSuperview()
//        })
//    }
    
    func searchAddress() -> Single<[String: Any]> {
        return Single.create { single in
            let kPostal = KPostalViewController()
            kPostal.completeHandler = { data in
                single(.success(data))
            }
            DefaultWireframe.rootViewController().present(kPostal, animated: true)
            return Disposables.create()
        }
    }

    static func presentAlert(_ message: String) {
        #if os(iOS)
            let alertView = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "확인", style: .cancel) { _ in
            })
            rootViewController().present(alertView, animated: true, completion: nil)
        #endif
    }

    

    func promptFor<Action : CustomStringConvertible>(_ message: String, cancelAction: Action, actions: [Action]) -> Observable<Action> {
        #if os(iOS)
        return Observable.create { observer in
            let alertView = UIAlertController(title: "RxExample", message: message, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: cancelAction.description, style: .cancel) { _ in
                observer.on(.next(cancelAction))
                observer.onCompleted()
            })

            for action in actions {
                alertView.addAction(UIAlertAction(title: action.description, style: .default) { _ in
                    observer.onCompleted()
                    observer.on(.next(action))
                })
            }

            DefaultWireframe.rootViewController().present(alertView, animated: true, completion: nil)

            return Disposables.create {
                alertView.dismiss(animated:false, completion: nil)
            }
        }
        #elseif os(macOS)
            return Observable.error(NSError(domain: "Unimplemented", code: -1, userInfo: nil))
        #endif
    }

    func promptAlert<Action : CustomStringConvertible>(_ title: String, message: String, actions: [Action]) -> Observable<Action> {
#if os(iOS)
        return Observable.create { observer in
            let alert = AlertViewController()
            alert.modalPresentationStyle = .overFullScreen

            alert.titleLabel.text = title
            alert.messageLabel.text = message
            actions.forEach { action in
                alert.addAction(title: action.description) { _ in
                    observer.on(.next(action))
                    observer.onCompleted()
                }
            }

            DefaultWireframe.rootViewController()
                .present(alert, animated: true, completion: nil)

            return Disposables.create {
                 alert.dismiss(animated:false, completion: nil)
            }
        }
#endif
    }
}
