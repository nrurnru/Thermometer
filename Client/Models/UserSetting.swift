import Combine

class UserSetting {
    var unit = CurrentValueSubject<TemperatureUnit, Never>(.celsius)
    
    func changeTemperatureUnit(to unit: TemperatureUnit) {
        self.unit.send(.celsius)
    }
}

