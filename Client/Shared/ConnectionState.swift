//
//  ConnectionState.swift
//  Thermometer
//
//  Created by 최광현 on 2022/06/25.
//

import Foundation

enum ConnectionState: CustomStringConvertible {
    case connected
    case disconnected
    case checking
    
    var description: String {
        switch self {
        case .connected:
            return "connected"
        case .disconnected:
            return "disconnected"
        case .checking:
            return "checking.."
        }
    }
}
