import Foundation

class TemperatureFormatter: NumberFormatter {
    override init() {
        super.init()
        self.numberStyle = .decimal
        self.minimumFractionDigits = 1
        self.maximumFractionDigits = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HumidityFormatter: NumberFormatter {
    override init() {
        super.init()
        self.numberStyle = .percent
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
