import CoreBluetooth

extension BLE: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // TODO: 권한, 설정OFF 분기
        guard central.state == .poweredOn else {
            dataContainer.updateState(state: .error(.centralBadState))
            return
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let localName: String = advertisementData[CBAdvertisementDataLocalNameKey] as? String ?? ""
        let isConnectable: Bool = (advertisementData[CBAdvertisementDataIsConnectable] as? NSNumber)?.boolValue ?? false
        let serviceUUIDs: [CBUUID] = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] ?? []
        let rssiValue:Int = RSSI.intValue
        Log.default("BLE Discovered peripheral: localName: \(localName), isconnectable: \(isConnectable), serviceUUID: \(serviceUUIDs) rssi: \(rssiValue)")
        
        self.peripheral = peripheral // !!referencing
        peripheral.delegate = self
        central.connect(peripheral, options: nil)
        dataContainer.updateState(state: .connecting)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        Log.default("BLE: didConnect peripheral", peripheral.name ?? "")
        central.stopScan()
        dataContainer.updateState(state: .connected)
        peripheral.discoverServices([serviceUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        Log.default("BLE: disconnected periphearl", peripheral.name ?? "")
        central.cancelPeripheralConnection(peripheral)
        dataContainer.updateState(state: .disconnected)
        self.peripheral = nil
    }
}
