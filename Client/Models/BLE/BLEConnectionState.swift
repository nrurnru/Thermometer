enum BLEConnectionState: CustomStringConvertible {
    case connected
    case disconnected
    case connecting
    case checking
    case notFound
    case error(BLEError)
    
    var description: String {
        switch self {
        case .connected:
            return "연결됨"
        case .connecting:
            return "연결중..."
        case .disconnected:
            return "연결되지 않음"
        case .checking:
            return "상태 확인중..."
        case .notFound:
            return "기기를 찾지 못했습니다."
        case .error(let error):
            return "오류"
        }
    }
    
    var isConnected: Bool {
        switch self {
        case .connected:
            return true
        default:
            return false
        }
    }
}
