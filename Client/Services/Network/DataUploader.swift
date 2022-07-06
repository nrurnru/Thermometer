import Combine

class DataUploader: BLECallBackReceiver {
    weak var network: Network?
    
    init(network: Network) {
        self.network = network
    }
    
    func updateValue(command: BLECommand) {
        switch command.commandType {
        case .humidity:
            guard let v = command.value else { break }
            let humidity = Humidity(value: v)
            network?.uploadHumidity(humidity: humidity)
        case .temperature:
            guard let v = command.value else { break }
            let temperature = Temperature(celsiusValue: Double(v)) // 기기한계
            network?.uploadTemperature(temperature: temperature)
        default:
            break
        }
    }
}
