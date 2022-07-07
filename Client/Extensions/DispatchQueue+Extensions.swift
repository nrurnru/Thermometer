import Foundation

extension DispatchQueue {
    static let ble = DispatchQueue(label: Constants.BLE.bleQueueLabel, qos: .background)
}
