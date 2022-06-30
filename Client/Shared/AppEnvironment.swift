//
//  AppEnvironment.swift
//  Thermometer
//
//  Created by 최광현 on 2022/06/26.
//

import Foundation

class AppEnvironment {
    @Published private(set) var isTestMode = false
    
    func enableTestmode() {
        self.isTestMode = true
    }
    
    func disableTestmode() {
        self.isTestMode = false
    }
}
