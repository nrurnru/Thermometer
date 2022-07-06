import OSLog

class Log {
    static let table = OSLog(subsystem: "\(Bundle.main.bundleIdentifier ?? "")", category: "\(Bundle.main.displayName ?? "")")
    
    static func `default`(_ objects: Any ..., name: String = #file, line: Int = #line) {
        Self.log(type: .default, objects: objects, name: name, line: line)
    }
    
    static func error(_ objects: Any ..., name: String = #file, line: Int = #line) {
        Self.log(type: .error, objects: objects, name: name, line: line)
    }
    
    private static func log(type: OSLogType, objects: Any, name: String, line: Int) {
        let file = name.components(separatedBy: "/").last ?? ""
        let object = (objects as? [Any] ?? [])
            .compactMap { "\($0)" }
            .joined(separator: String(Character.space))
        let message = "\(file) \(line)L\(Character.newLine)\(object)"
        os_log("%{public}@", log: Self.table, type: type, message)
    }
}
