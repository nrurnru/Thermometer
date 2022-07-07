import UIKit

class Network: NSObject {
    static let defaultSession = URLSession(configuration: .ephemeral)
    private var baseURL = Constants.Network.baseURL
    
    func uploadTemperature(temperature: Temperature, completion: ResultCompletion<IDResult>? = nil) {
        let url = URL(string: baseURL.appending("/temperature"))!
        let container = NetworkContainer(url: url, method: .post, object: temperature)
        container.startBackgroundRequest(completion: completion)
    }
    
    func uploadHumidity(humidity: Humidity, completion: ResultCompletion<IDResult>? = nil) {
        let url = URL(string: baseURL.appending("/humidity"))!
        let container = NetworkContainer(url: url, method: .post, object: humidity)
        container.startBackgroundRequest(completion: completion)
    }
}
