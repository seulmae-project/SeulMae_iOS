import struct Foundation.URL

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
    var parameters: Parameters? { get }
    var body: Encodable? { get }
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
    
    var task: Task {
        if let body { return .requestJSONEncodable(body)
        } else if let parameters {
            return .requestParameters(parameters: parameters.values, encoding: parameters.encoding)
        } else {
            return .requestPlain
        }
    }
}
