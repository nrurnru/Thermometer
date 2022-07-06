import Foundation

struct BLECommand {
    let commandType: CommandType
    let value: Int?
    
    enum CommandType: String {
        case relay = "RELAY"
        case humidity = "HUMID"
        case temperature = "TEMP"
        case buzzer = "BUZZER"
    }
    
    init?(string: String) {
        let com = String(string.filter { $0.isLetter }.compactMap { $0 })
        let val = Int(String(string.filter { $0.isNumber }.compactMap { $0 }))
        
        guard let type = CommandType(rawValue: com) else { return nil }
        self.commandType = type
        self.value = val
    }
    
    init(command: CommandType, value: Int? = nil) {
        self.commandType = command
        self.value = value
    }
    
    func output() -> String {
        return "<\(commandType.rawValue)>\(value?.description ?? "")\(Character.semicolon)"
    }
}
