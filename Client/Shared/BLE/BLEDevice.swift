//
//  BLEService.swift
//  Thermometer
//
//  Created by 최광현 on 2022/02/25.
//

import Foundation
import CoreBluetooth

class BLEDevice {
    let centerManger: CBCentralManager
    let peipheral: CBPeripheral
    
    init(centralManager: CBCentralManager, peipheral: CBPeripheral) {
        self.centerManger = centralManager
        self.peipheral = peipheral
    }
}

