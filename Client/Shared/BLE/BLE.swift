//
//  BLE.swift
//  Thermometer
//
//  Created by 최광현 on 2022/06/28.
//

import CoreBluetooth
import Combine

class BLE: NSObject {
    let receiver: BLEResultHandler
    
    let serviceUUID = CBUUID(string: Constants.BLE.serviceUUID)
    let configUUID = CBUUID(string: Constants.BLE.serialUUID)

    var bCentralPowerOn = false // ?
    var connected = false
    
    var centralManager: CBCentralManager?
    var peripheral: CBPeripheral?
    var device: BLEDevice?
    
    init(callBackReceiver: BLEResultHandler) {
        self.receiver = callBackReceiver
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func scan() {
        print("BLE: 스캔 시작")
        self.centralManager?.scanForPeripherals(withServices: [serviceUUID])
//        guard let peripherals = centralManager?.retrieveConnectedPeripherals(withServices: [kService]) else { return }
//        guard let target = peripherals.first else { return } // TODO: 기준 설정
//        self.centralManager?.connect(target)
    }
    
    func write(msg: String) {
        guard let data = msg.data(using: .utf8), data.count <= Constants.BLE.kMaxLength else { return }
        self.writeCharacteristic(self.peripheral, sCBUUID: serviceUUID, cCBUUID: configUUID, data: data)
    }
    
    func disconnect() {
        guard let peripheral = peripheral else { return }
        self.centralManager?.cancelPeripheralConnection(peripheral)
    }
    
    func writeCharacteristic(_ peripheral: CBPeripheral?, sCBUUID: CBUUID?, cCBUUID: CBUUID?, data: Data?) {
        print("BLE: writeCharacteristic 서비스 \(peripheral?.services)")
        guard let peripheral = peripheral else { return print("no peripheral!") }
        guard let data = data else { return print("no data!") }
        
        peripheral.services?
            .filter { $0.uuid == sCBUUID }
            .compactMap { $0.characteristics }
            .flatMap { $0 }
            .filter { $0.uuid == cCBUUID }
            .forEach { characteristic in
                peripheral.writeValue(data, for: characteristic, type: .withResponse)
            }
    }
    
    func setNotificationForCharacteristic(_ peripheral: CBPeripheral?, sCBUUID: CBUUID?, cCBUUID: CBUUID?, enable: Bool) {
        guard let peripheral = peripheral else { return print("no peripheral!") }

        peripheral.services?
            .filter { $0.uuid == sCBUUID }
            .compactMap { $0.characteristics }
            .flatMap { $0 }
            .filter { $0.uuid == cCBUUID }
            .forEach { characteristic in
                print("setNotificationForCharacteristic \(characteristic)")
                peripheral.setNotifyValue(enable, for: characteristic)
            }
    }
}

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

struct BLECommand {
    let command: CommandProtocol
    let value: Int?
    
    enum CommandProtocol: String {
        case relay = "RELAY"
        case humid = "HUMID"
        case temperature = "TEMP"
        case buzzer = "BUZZER"
    }
    
    init?(command: String, value: Int?) {
        guard let command = CommandProtocol(rawValue: command) else { return nil }
        self.command = command
        self.value = value
    }
    
    init(command: CommandProtocol, value: Int) {
        self.command = command
        self.value = value
    }
    
    func output() -> String {
        return "<\(command.rawValue)>\(value?.description ?? "");"
    }
}
