//
//  BLE+CBCentralManagerDelegate.swift
//  Thermometer
//
//  Created by 최광현 on 2022/06/28.
//

import CoreBluetooth

extension BLE: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("BLECentral: didUpdateState")
        guard central.state == .poweredOn else {
            self.bCentralPowerOn = false
            return
        }
        dump(central)
        self.bCentralPowerOn = true
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("BLECentral: didDiscover!")
        
        let isConnectable: NSNumber? = advertisementData[CBAdvertisementDataIsConnectable] as? NSNumber
        let localName: String? = advertisementData[CBAdvertisementDataLocalNameKey] as? String
        let serviceUUIDs: [CBUUID]? = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID]
        let rssiValue:Int = RSSI.intValue

        print("isconnectable: \(isConnectable?.boolValue), localName: \(localName) serviceUUID: \(serviceUUIDs) rssi: \(rssiValue)")
        
        peripheral.delegate = self
        central.connect(peripheral, options: nil)
        self.peripheral = peripheral
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("BLECentral: didConnect")
        central.stopScan()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.setConnected()
        }
        
        guard let central = self.centralManager, let peripheral = self.peripheral else { return print("central peripheral?") }
        self.device = BLEDevice(centralManager: central, peipheral: peripheral)
        
        peripheral.discoverServices([serviceUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("BLECentral: didDisconnect")
        self.centralManager?.cancelPeripheralConnection(peripheral)
        self.setDisconnected()
        self.peripheral = nil
        self.device = nil
        
//        self.centralManager?.scanForPeripherals(withServices: [serviceUUID], options: nil)
    }
    
    private func setConnected() {
        self.connected = true
    }
    
    private func setDisconnected() {
        self.connected = false
    }
}

