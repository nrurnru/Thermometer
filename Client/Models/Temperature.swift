import Foundation

struct Temperature: Codable {
    let celsiusValue: Double
    
    func convert(to unit: TemperatureUnit) -> Double {
        return Measurement(value: celsiusValue, unit: .celsius).converted(to: unit.unit).value
    }
    
    func displayValue(with unit: TemperatureUnit) -> String {
        let converted = convert(to: unit)
        guard let value = TemperatureFormatter().string(from: converted as NSNumber) else {
            return unit.symbol
        }
        return "\(value)\(unit.symbol)"
    }
    
    enum CodingKeys: String, CodingKey {
        case celsiusValue = "value"
    }
}

