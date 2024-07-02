
import Foundation

enum APIError: Error {
    case empty(_ path: String)
    case failedToRequestSMSVerification
    case failedToSMSVerification
    case faildedToSignup
    case faildedToSignin(_ reason: String)
    case failedWithReason(_ reason: String)
    
    case unauthorized(_ reason: String)
}


