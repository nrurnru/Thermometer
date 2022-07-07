enum RepositoryError: Error, CustomStringConvertible {
    case network
    case database
    case bluetooth
    case unknown
    
    var description: String {
        switch self {
        case .network:
            return "network error."
        case .database:
            return "db error."
        case .bluetooth:
            return "BLE error."
        case .unknown:
            return "unknown error."
        }
    }
}

