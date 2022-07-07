import Foundation

enum BLEError: LocalizedError {
    case centralBadState
    case unknown(Error?)
    
    var localizedDescription: String {
        switch self {
        case .centralBadState:
            return "central in bad state."
        case .unknown(let error):
            return error?.localizedDescription ?? "unknown error."
        }
    }
}
