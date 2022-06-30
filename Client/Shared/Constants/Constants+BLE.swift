//
//  Constants+BLE.swift
//  Thermometer
//
//  Created by 최광현 on 2022/06/28.
//

struct Constants {
    // ?
}

extension Constants {
    struct BLE {
        static let kMaxLength = 20
        static let kMinLength = 40
        
        static let serviceUUID = "0000dfb0-0000-1000-8000-00805f9b34fb"
        static let serialUUID = "0000dfb1-0000-1000-8000-00805f9b34fb"
        
        static let bleQueueLabel = "in.co.coincoin.bleQueue"
    }
}

