import CoreBluetooth

class BLE: NSObject {
    let dataUploader: DataUploader
    let dataContainer: DataContainer
    
    let serviceUUID = CBUUID(string: Constants.BLE.serviceUUID)
    let configUUID = CBUUID(string: Constants.BLE.serialUUID)

    var centralManager: CBCentralManager?
    var peripheral: CBPeripheral?
    
    var scanTimer = Timer()
    
    init(dataUploader: DataUploader, dataContainer: DataContainer) {
        self.dataUploader = dataUploader
        self.dataContainer = dataContainer
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.ble)
    }
    
    func scan() {
        Log.default("BLE: 스캔 시작")
        if let connectedPeripherals = centralManager?.retrieveConnectedPeripherals(withServices: [serviceUUID]), let target = connectedPeripherals.first {
            centralManager?.connect(target)
            return
        }
        
        centralManager?.scanForPeripherals(withServices: [serviceUUID])
        
        self.scanTimer = Timer.scheduledTimer(withTimeInterval: Constants.BLE.scanLimit, repeats: false) { [weak self] _ in
            guard self?.centralManager?.isScanning ?? false else { return }
            Log.default("BLE: 스캔 실패")
            self?.dataContainer.updateState(state: .notFound)
            self?.centralManager?.stopScan()
        }
    }
    
    func write(msg: String) {
        guard let data = msg.data(using: .utf8), data.count <= Constants.BLE.maxLength else { return }
        writeCharacteristic(self.peripheral, sCBUUID: serviceUUID, cCBUUID: configUUID, data: data)
    }
    
    func disconnect() {
        guard let peripheral = peripheral else { return }
        centralManager?.cancelPeripheralConnection(peripheral)
        self.scanTimer.invalidate()
        dataContainer.updateState(state: .disconnected)
    }
    
    func writeCharacteristic(_ peripheral: CBPeripheral?, sCBUUID: CBUUID?, cCBUUID: CBUUID?, data: Data?) {
        guard let data = data else { return Log.default("Tried to send empty Data.") }
        peripheral?.services?
            .filter { $0.uuid == sCBUUID }
            .compactMap { $0.characteristics }
            .flatMap { $0 }
            .filter { $0.uuid == cCBUUID }
            .forEach { characteristic in
                peripheral?.writeValue(data, for: characteristic, type: .withResponse)
            }
    }
}

