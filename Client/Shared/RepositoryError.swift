//
//  RepositoryError.swift
//  Thermometer
//
//  Created by 최광현 on 2022/06/26.
//

import Foundation

enum RepositoryError: Error, CustomStringConvertible {
    case network
    case database
    case bluetooth
    case unknown
    
    var description: String {
        switch self {
        case .network:
            return "network error."
        case .database:
            return "db error."
        case .bluetooth:
            return "BLE error."
        case .unknown:
            return "unknown error."
        }
    }
}

