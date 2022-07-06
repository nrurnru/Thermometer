import Foundation

enum NetworkError: LocalizedError {
    case networkResponseNotExist
    case networkDataNotExist
    case serverDataNotExist
    case networkingFailed(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .networkingFailed(let statusCode):
            return "network Failed, code: \(statusCode)"
        default:
            return "\(self)"
        }
    }
}

