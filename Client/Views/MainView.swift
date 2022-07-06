import SwiftUI
import Combine

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        ZStack {
            Color.skyBlue.edgesIgnoringSafeArea(.all)
            VStack(alignment: .center, spacing: 60) {
                VStack {
                    Text(viewModel.temperatureMessage).padding()
                    Text(viewModel.humidityMessage).padding()
                    Text(viewModel.connectionState.description).padding()
                }
                .baseFont(size: .middle)
                HStack {
                    Button("연결") {
                        viewModel.connect()
                    }
                    .foregroundColor(viewModel.connectionState.isConnected ? .lightGrey : .pureWhite)
                    .disabled(viewModel.connectionState.isConnected)
                    Button("해제") {
                        viewModel.disconnect()
                    }
                    .foregroundColor(!viewModel.connectionState.isConnected ? .lightGrey : .pureWhite)
                    .disabled(!viewModel.connectionState.isConnected)
                    Button("새로고침") {
                        viewModel.refresh()
                    }
                    .foregroundColor(!viewModel.connectionState.isConnected ? .lightGrey : .pureWhite)
                    .disabled(!viewModel.connectionState.isConnected)
                }
                HStack {
                    Text(TemperatureUnit.fahrenheit.symbol)
                    Toggle("", isOn: $viewModel.isCelsius)
                        .labelsHidden()
                        .tint(.clear)
                    Text(TemperatureUnit.celsius.symbol)
                }
            }.foregroundColor(.pureWhite)
            .popover(isPresented: $viewModel.isPresentErrorPopup) {
                ErrorPopup(viewModel: ErrorPopupViewModel(diContainer: viewModel.diContainer, error: viewModel.error ?? .unknown, isPresent: $viewModel.isPresentErrorPopup))
            }
        }.baseFont(size: .middle)
    }
}

class MainViewModel: CommonViewModel {
    @Published private(set) var connectionState: BLEConnectionState = .disconnected
    @Published private(set) var testModeDescription: String = ""
    @Published var error: RepositoryError? = nil
    @Published var isPresentErrorPopup: Bool = false
    @Published var temperatureMessage = "--"
    @Published var humidityMessage = "--"
    @Published var isCelsius: Bool = true
    
    override func bind() {
        super.bind()
        self.diContainer.appEnvironment.isTestMode
            .receive(on: DispatchQueue.main)
            .map { $0 ? "Test mode ON" : "Test mode OFF" }
            .assign(to: &$testModeDescription)
        
        self.diContainer.ble.dataContainer.temperatureMessage
            .combineLatest(self.diContainer.userSetting.unit)
            .map { temp, unit in
                temp.displayValue(with: unit)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$temperatureMessage)
        
        self.diContainer.ble.dataContainer.humidityMessage
            .map { $0.displayValue() }
            .receive(on: DispatchQueue.main)
            .assign(to: &$humidityMessage)
        
        self.diContainer.ble.dataContainer.state
            .receive(on: DispatchQueue.main)
            .assign(to: &$connectionState)
        
        self.diContainer.userSetting.unit
            .removeDuplicates()
            .map { $0 == .celsius }
            .sink { [weak self] in
                self?.isCelsius = $0
            }.store(in: &bag)
        
        self.$isCelsius
            .removeDuplicates()
            .map { $0 ? TemperatureUnit.celsius : .fahrenheit }
            .sink { [weak self] in
                self?.diContainer.userSetting.unit.send($0)
            }.store(in: &bag)
        
        self.$error
            .compactMap { $0 }
            .sink { [weak self] _ in
                self?.isPresentErrorPopup = true
            }.store(in: &bag)
    }
    
    func connect() {
        diContainer.ble.scan()
    }
    
    func disconnect() {
        diContainer.ble.disconnect()
    }
    
    func refresh() {
        diContainer.ble.write(msg: BLECommand(command: .temperature).output())
        diContainer.ble.write(msg: BLECommand(command: .humidity).output())
    }
}
