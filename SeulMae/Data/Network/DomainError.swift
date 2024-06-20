
import Foundation

enum DomainError: Error {
    case empty(_ path: String)
    case failedToRequestSMSVerification
    case failedToSMSVerification
    case faildedToSignup
    case faildedToSignin
}
