//
//  DispatchQueue+Extensions.swift
//  Thermometer
//
//  Created by 최광현 on 2022/06/28.
//

import Foundation

extension DispatchQueue {
    static let upload  =  DispatchQueue(label: Constants.Network.uploadQueueLabel, qos: .background)
    static let download = DispatchQueue(label: Constants.Network.downloadQueueLabel, qos: .background)
    static let ble = DispatchQueue(label: Constants.BLE.bleQueueLabel, qos: .background)
}
