import Foundation

struct Humidity: Codable {
    let value: Int
    
    func displayValue() -> String {
        let formatter  = HumidityFormatter()
        let converted = Double(value) / 100
        guard let value = formatter.string(from: converted as NSNumber) else {
            return formatter.percentSymbol
        }
        return "\(value)"
    }
}
