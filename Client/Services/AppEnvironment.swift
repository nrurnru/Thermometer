import Combine

class AppEnvironment {
    private(set) var isTestMode = CurrentValueSubject<Bool, Never>(false)
    
    func enableTestmode() {
        self.isTestMode.send(true)
    }
    
    func disableTestmode() {
        self.isTestMode.send(false)
    }
}
