//
//  ThermometerApp.swift
//  Shared
//
//  Created by 최광현 on 2022/02/24.
//

import SwiftUI

@main
struct ThermometerApp: App {
    private let appEnvironment = AppEnvironment()
    private let userSetting = UserSetting()
    private let network = Network()
    private let ble = BLE(callBackReceiver: BLEResultHandler())
    
    var body: some Scene {
        WindowGroup {
            let DI = DI(
                appEnvironment: appEnvironment,
                userSetting: userSetting,
                network: network,
                ble: ble)
            let vm = MainViewModel(DI: DI)
            MainView(viewModel: vm)
        }
    }
}
