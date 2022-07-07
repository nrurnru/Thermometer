import Combine

class DataContainer: BLECallBackReceiver {
    var temperatureMessage = PassthroughSubject<Temperature, Never>()
    var humidityMessage = PassthroughSubject<Humidity, Never>()
    var state = PassthroughSubject<BLEConnectionState, Never>()
    
    func updateState(state: BLEConnectionState) {
        self.state.send(state)
    }
    
    func updateValue(command: BLECommand) {
        switch command.commandType {
        case .temperature:
            guard let v = command.value else { break }
            let temperature = Temperature(celsiusValue: Double(v))
            self.temperatureMessage.send(temperature)
        case .humidity:
            guard let v = command.value else { break }
            let humidity = Humidity(value: v)
            self.humidityMessage.send(humidity)
        default:
            break
        }
    }
}
