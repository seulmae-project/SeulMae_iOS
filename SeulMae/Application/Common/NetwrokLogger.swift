//
//  NetwrokLogger.swift
//  SeulMae
//
//  Created by 조기열 on 9/18/24.
//

import Foundation
import Alamofire
import Moya

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
        print("🛰 NETWORK Reqeust LOG")
        print(request.description)
        
        print(
            "URL: " + (request.request?.url?.absoluteString ?? "")  + "\n"
            + "Method: " + (request.request?.httpMethod ?? "") + "\n"
            + "Headers: " + "\(request.request?.allHTTPHeaderFields ?? [:])" + "\n"
        )
        print("Authorization: " + (request.request?.headers["Authorization"] ?? ""))
        print("Body: " + (request.request?.httpBody?.toPrettyPrintedString ?? ""))
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("🛰 NETWORK Response LOG")
        print(
            "URL: " + (request.request?.url?.absoluteString ?? "") + "\n"
            + "Result: " + "\(response.result)" + "\n"
            + "StatusCode: " + "\(response.response?.statusCode ?? 0)" + "\n"
            + "Data: \(response.data?.toPrettyPrintedString ?? "")"
        )
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
