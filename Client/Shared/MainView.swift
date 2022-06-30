//
//  ContentView.swift
//  Shared
//
//  Created by 최광현 on 2022/02/24.
//

import SwiftUI
import Combine

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        ZStack {
            Color.white
            VStack(alignment: .center, spacing: 60) {
                Text(viewModel.connectionState.description).foregroundColor(Color.black)
                Button("Error") {
                    viewModel.occurrError()
                }
                Button("Connect") {
                    viewModel.connect()
                }
                Button("Disconnect") {
                    viewModel.disconnect()
                }
                Button("Push") {
                    viewModel.push()
                }
                Text(viewModel.message).foregroundColor(Color.green)
                Text(viewModel.testModeDescription).foregroundColor(Color.black)
            }.popover(isPresented: $viewModel.isPresentErrorPopup) {
                let vm = ErrorPopupViewModel(DI: viewModel.DI, error: viewModel.error ?? .unknown, isPresent: $viewModel.isPresentErrorPopup)
                ErrorPopup(viewModel: vm)
            }
        }.baseFont(size: .small)
    }
}

class MainViewModel: CommonViewModel {
    @Published private(set) var connectionState: ConnectionState = .disconnected
    @Published private(set) var testModeDescription: String = ""
    @Published var error: RepositoryError? = nil
    @Published var isPresentErrorPopup: Bool = false
    @Published var message = "?"
    
    override func bind() {
        super.bind()
        self.DI.appEnvironment.$isTestMode
            .map { $0 ? "Test mode ON" : "Test mode OFF" }
            .assign(to: &$testModeDescription)
        
        self.$error
            .compactMap { $0 }
            .sink { [weak self] _ in
                self?.isPresentErrorPopup = true
            }.store(in: &bag)
        
        self.DI.ble.receiver.$message
            .assign(to: &$message)
    }
    
    func occurrError() {
        error = Bool.random() ? .network : .database
        isPresentErrorPopup = true
    }
    
    func connect() {
        DI.ble.scan()
        connectionState = .connected
    }
    
    func disconnect() {
        DI.ble.disconnect()
        connectionState = .disconnected
    }
    
    func push() {
//        connectionState = .checking
        print("push")
        let onOff = Bool.random().intValue
        
        let com = DI.appEnvironment.isTestMode ? BLECommand.CommandProtocol.buzzer : BLECommand.CommandProtocol.relay
        let msgs = BLECommand(command: com, value: onOff).output()
        DI.ble.write(msg: msgs)
    }
}

struct DI {
    var appEnvironment: AppEnvironment
    var userSetting: UserSetting
    var network: Network
    var ble: BLE
}

class Network {
    
}

class UserSetting {
    
}
