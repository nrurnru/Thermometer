//
//  ThermometerApp.swift
//  Shared
//
//  Created by 최광현 on 2022/02/24.
//

import SwiftUI

@main
struct ThermometerApp: App {
    var body: some Scene {
        WindowGroup {
            let appEnvironment = AppEnvironment()
            let userSetting = UserSetting()
            let network = Network()
            let dataUploader = DataUploader(network: network)
            let datacontainer = DataContainer()
            let ble = BLE(dataUploader: dataUploader, dataContainer: datacontainer)
            
            let diContainer = DIContainer(
                appEnvironment: appEnvironment,
                userSetting: userSetting,
                network: network,
                ble: ble
            )
            let vm = MainViewModel(diContainer: diContainer)
            MainView(viewModel: vm)
        }
    }
}
