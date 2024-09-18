import struct Foundation.URL
import Foundation
import struct Foundation.Data
import Darwin.C.stdlib


import Moya

public protocol SugarTargetType: TargetType {
    var url: URL { get }
    
    /// Returns `Route` which contains HTTP method and URL path information.
    ///
    /// Example:
    ///
    /// ```
    /// var route: Route {
    ///   return .get("/me")
    /// }
    /// ```
    var route: Route { get }
    var task: Task { get }
//    var parameters: Parameters? { get }
//    var body: Encodable? { get }
//    var data: Data? { get }
}

public extension SugarTargetType {
    var url: URL {
        return self.defaultURL
    }
    
    var defaultURL: URL {
        return self.path.isEmpty ? self.baseURL : self.baseURL.appendingPathComponent(self.path)
    }
    
    var path: String {
        return self.route.path
    }
    
    var method: Moya.Method {
        return self.route.method
    }
    
    var task: Moya.Task {
        return self.task
    }
    
//    var task: Task {
//        if let data {
//            var formData = [MultipartFormData]() // file
//            let file = MultipartFormData(provider: .data(data), name: "multipartFileList", fileName: "\(arc4random()).jpeg", mimeType: "image/jpeg")
//            formData.append(file)
//            guard let bodyDic = body as? [String: Encodable] else {
//                return .uploadMultipart(formData)
//            }
//            let encoder = JSONEncoder()
//            for (key, value) in bodyDic {
//                Swift.print("key: \(key), value: \(value)")
//                if let json = try? encoder.encode(value) {
//                    formData.append(MultipartFormData(provider: .data(json), name: key, mimeType: "application/json"))
//                }
//            }
//            return .uploadMultipart(formData)
//        }
//        
//        if let body, let parameters {
//            let encoder = JSONEncoder()
//            let data = try? encoder.encode(body)
//            return .requestCompositeData(bodyData: data ?? Data(), urlParameters: parameters.values)
//        } else if let body {
//            return .requestJSONEncodable(body)
//        } else if let parameters {
//            return .requestParameters(parameters: parameters.values, encoding: parameters.encoding)
//        } else {
//            return .requestPlain
//        }
//    }
}
