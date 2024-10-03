//
//  NetwrokLogger.swift
//  SeulMae
//
//  Created by 조기열 on 9/18/24.
//

import Foundation
import Alamofire
import Moya

//extension Moya.Response {
//    var toPrettyPrintedString: String? {
//        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
//              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
//              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
//        return prettyPrintedString as String
//    }
//    func mapPrettyString(atKeyPath keyPath: String? = nil) throws -> String {
//        if let keyPath = keyPath {
//            guard let jsonDictionary = try mapJSON() as? NSDictionary,
//                let string = jsonDictionary.value(forKeyPath: keyPath) as? String else {
//                    throw MoyaError.stringMapping(self)
//            }
//            return string
//        } else {
//            // Key path was not provided, parse entire response as string
//            guard let string = String(data: data, encoding: .utf8) else {
//                throw MoyaError.stringMapping(self)
//            }
//            return string
//        }
//    }
//}


extension Session {
    static let custom: Session = {
        let configuration = URLSessionConfiguration.af.default
        let apiLogger = NetwrokLogger()
        return Session(configuration: configuration, eventMonitors: [apiLogger])
    }()
}

final class NetwrokLogger: EventMonitor {
    let queue = DispatchQueue(label: "netwrok_logger")
    
    func requestDidFinish(_ request: Request) {
        Swift.print("🛰 NETWORK Reqeust LOG")
        Swift.print("URL: " + (request.request?.url?.absoluteString ?? "")  + "\n"
                    + "Method: " + (request.request?.httpMethod ?? "") + "\n"
                    + "Body: " + "\(request.request?.httpBody?.toPrettyPrintedString ?? "")" + "\n")
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("🛰 NETWORK Response LOG")
        print("URL: " + (request.request?.url?.absoluteString ?? "") + "\n"
              + "Result: " + "\(response.result)" + "\n"
              + "StatusCode: " + "\(response.response?.statusCode ?? 0)" + "\n"
              + "Data: \(response.data?.toPrettyPrintedString ?? "")")
    }
}

extension Data {
    var toPrettyPrintedString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString as String
    }
}


final class CustomNetworkLoggerPlugin: PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        Swift.print("""
            🛰 NETWORK Reqeust LOG
                URL: \(request.request?.url?.absoluteString ?? "")
                Method: \(request.request?.httpMethod ?? "")
                Body: \(request.request?.httpBody?.toPrettyPrintedString ?? "")
                Header: \(request.request?.headers.description ?? "")
            """)
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let response):
            if let json = try? response.mapJSON(),
               let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
               let jsonString = String(data: data, encoding: .utf8) {
                let escaped = jsonString.replacingOccurrences(of: "\\", with: "")
                Swift.print("🛰 Received response: \(escaped)")
            } else {    
                Swift.print("🛰 Can't convert response to JSON or serialize it...")
            }
        case .failure(let error):
            Swift.print("🛰 Request failed with error: \(error)")
        }
    }
}
