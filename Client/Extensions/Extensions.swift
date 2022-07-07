import Foundation

extension Bool {
    var intValue: Int {
        return self ? 1 : 0
    }
}

extension Int {
    var boolValue: Bool {
        return self == 0 ? false : true
    }
}

extension Bundle {
    var displayName: String? {
        Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
    }
}
