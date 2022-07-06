import CoreBluetooth

extension BLE: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        peripheral.services?.forEach {
            Log.default("Discovered services: ", $0.description)
            peripheral.discoverCharacteristics([self.configUUID], for: $0)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        service.characteristics?.forEach {
            Log.default("Discovered characteristic: ", $0.uuid)
        }
        
        peripheral.services?
            .filter { $0.uuid == serviceUUID }
            .compactMap { $0.characteristics }
            .flatMap { $0 }
            .filter { $0.uuid == configUUID }
            .forEach { characteristic in
                Log.default("Notification 설정", characteristic.uuid)
                peripheral.setNotifyValue(true, for: characteristic)
            }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if (error as? CBATTError)?.code == .attributeNotFound {
            // TODO: 기기에서 descriptor 지원시 구분
        } else {
            if let error = error {
                Log.error("BLE 오류 발생:", error)
                dataContainer.updateState(state: .error(.unknown(error)))
            } else {
                Log.error("BLE 상태 업데이트:", characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard characteristic.uuid == configUUID else { return }
        guard let data = characteristic.value, let value = String(data: data, encoding: .utf8) else { return }
        if let error = error {
            dataContainer.updateState(state: .error(.unknown(error)))
            return Log.error("BLE 오류 발생:", error)
        }
        
        Log.default("BLE 값 업데이트", characteristic.uuid, value)
        value
            .components(separatedBy: String(Character.semicolon))
            .compactMap {
                BLECommand(string: $0)
            }.forEach {
                dataContainer.updateValue(command: $0)
                dataUploader.updateValue(command: $0)
            }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            Log.error("BLE write error", error)
        }
        guard let value = String(data: characteristic.value ?? Data(), encoding: .utf8) else { return }
        Log.default("BLE 요청:", value, characteristic.uuid)
    }
    
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        Log.default("BLE: didFailToConnect", error?.localizedDescription ?? "")
        dataContainer.updateState(state: .error(.unknown(error)))
    }
}
