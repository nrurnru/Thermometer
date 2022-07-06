import Foundation

struct ServerError: Codable, LocalizedError {
    let code: ErrorCode
    
    enum ErrorCode: Int, Codable {
        case undefined = -1
        case valueRangeError = 100
        case noApptoken = 101
        case tokenExpired = 2
    }

    var errorDescription: String? {
        switch code {
        case .noApptoken:
            return "앱 토큰 없음."
        case .valueRangeError:
            return "온도가 너무 높거나 낮음."
        default:
            return "정의되지 않은 오류."
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = ErrorCode(rawValue: try container.decode(Int.self, forKey: .code)) ?? .undefined
    }
}
