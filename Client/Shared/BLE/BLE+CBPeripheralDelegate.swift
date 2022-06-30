//
//  BLE+CBPeripheralDelegate.swift
//  Thermometer
//
//  Created by 최광현 on 2022/06/28.
//

import CoreBluetooth
import SwiftUI

extension BLE: CBPeripheralDelegate {
//    func configureSensorTag() {
//
//    }
//
//    func makeSensorTagConfiguration() -> [String: String] {
//        /// 태그
//        var d = [String: String]()
//        d["DF xiaomi service UUID"] = "dfb0"
//        d["DF xiaomi data UUID"] = "dfb1"
//        d["DF xiaomi config UUID"] = "dfb1"
//
//        return d
//    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        /// 페리페랄에서 서비스를 찾음
        print("service count: \(peripheral.services?.count)")
        print("BLE: \(peripheral.services)")
        for s in peripheral.services! {
            dump("BBBLLLEEE: service: \(s)")
            peripheral.discoverCharacteristics(nil, for: s)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        /// 서비스에서 캐릭터를 찾음
        service.characteristics?.forEach({ chara in
            dump("BBBLLLEEE: characteristic: \(chara)")
            dump("BBBLLLEEE: descroptiorawr!!ic: \(chara.descriptors), \(chara.description), \(peripheral.name)") // wil be deleted
        })
        guard service.uuid == serviceUUID else { return }
        setNotificationForCharacteristic(self.device?.peipheral, sCBUUID: serviceUUID, cCBUUID: configUUID, enable: true)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if (error as? CBATTError)?.code == .attributeNotFound {
            // 기기에서 지원하지 않음
        } else {
            print("BLE: 캐릭터에서 문제 발생 didUpdateNotificationStateFor \(characteristic.uuid) \(error)")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard self.connected else { return print("BLE: 미연결상태") }
        guard characteristic.uuid == configUUID,
              let v = characteristic.value,
              let value = String(data: v, encoding: .utf8),
              error == nil else {
                  return print("error happend: \(error?.localizedDescription)")
              }
        print("BLE: 캐릭터에서 값 반환, \(value)")

        value
            .components(separatedBy: ";")
            .compactMap { command -> BLECommand? in
                let com = String(command.filter { $0.isLetter }.compactMap { $0 })
                let val = Int(String(command.filter { $0.isNumber }.compactMap { $0 }))
                return BLECommand(command: com, value: val)
            }.forEach {
                receiver.updateValue(command: $0)
            }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        let v = String(data: characteristic.value ?? Data(), encoding: .utf8)
        dump(characteristic.descriptors)
        print("BLE: didwrite 캐릭터에서 값 반환, \(characteristic.uuid), notifying :\(characteristic.isNotifying) \(v), \(error)")
    }
}

protocol BLECallBackReceiver {
    func updateValue(command: BLECommand)
}

class BLEResultHandler: BLECallBackReceiver {
    @Published var message = "aa"
    
    func updateValue(command: BLECommand) {
        switch command.command {
        case .relay:
            break
        case .humid:
            break
        case .temperature:
            if let v = command.value {
                self.message = "\(v)"
            }
        case .buzzer:
            break
        }
    }
}

enum BLEError: LocalizedError {
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .unknown:
            return "unknown"
        }
    }
}
