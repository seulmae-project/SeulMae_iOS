//
//  AuthPlugin.swift
//  SeulMae
//
//  Created by 조기열 on 9/26/24.
//

import Moya

class AuthPlugin: PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        // 요청 헤더에 access token을 추가합니다.
        // 예: request.headers["Authorization"] = "Bearer \(accessToken)"
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let response):
            if response.statusCode == 401 {
                // 401 오류가 발생하면 refresh token 로직을 실행
//                refreshAccessToken().subscribe(onNext: { success in
//                    if success {
//                        // 새로운 access token을 사용하여 원래 요청을 재시도
//                    } else {
//                        // refresh token 실패 처리
//                    }
//                }).disposed(by: DisposeBag())
            }
        case .failure(let error):
            // 오류 처리
            print("Error: \(error)")
        }
    }

//    private func refreshAccessToken() -> Observable<Bool> {
//        return Observable.create { observer in
//            // Refresh token 요청 로직을 구현
//            // 요청 후 성공 시 observer.onNext(true), 실패 시 observer.onNext(false)
//            // observer.onCompleted() 호출 필요
//            
//            // 예시: 성공적인 refresh token 요청
//            // observer.onNext(true) // 또는 false로 실패 처리
//            // observer.onCompleted()
//            
//            return Disposables.create()
//        }
//    }
}
