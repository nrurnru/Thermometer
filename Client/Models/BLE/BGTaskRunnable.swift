import UIKit

protocol BGTaskRunnable: AnyObject {
    var bgTask: UIBackgroundTaskIdentifier { get set }
}

extension BGTaskRunnable {
    func startBackgroundTask(name: String, expirationHandler handler: VoidClosure? = nil) {
        self.bgTask = UIApplication.shared.beginBackgroundTask(withName: name, expirationHandler: handler)
        Log.default("Background Task 시작", self.bgTask.rawValue)
    }
    
    func endBackgroundTask() {
        UIApplication.shared.endBackgroundTask(self.bgTask)
        Log.default("Background Task 끝", self.bgTask.rawValue)
        self.bgTask = .invalid
    }
}
