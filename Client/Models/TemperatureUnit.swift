import Foundation

enum TemperatureUnit: Codable {
    case celsius
    case fahrenheit
    
    var unit: UnitTemperature {
        switch self {
        case .celsius:
            return .celsius
        case .fahrenheit:
            return .fahrenheit
        }
    }
    
    var symbol: String {
        return self.unit.symbol
    }
}
