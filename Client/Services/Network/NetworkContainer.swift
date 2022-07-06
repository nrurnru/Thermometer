import UIKit

class NetworkContainer: BGTaskRunnable {
    private var request: URLRequest
    var bgTask = UIBackgroundTaskIdentifier.invalid
    
    init(url: URL, method: HTTPMethod, header: HTTPHeader = [:]) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        header.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.setValue(Constants.Secrets.appToken, forHTTPHeaderField: "appToken")
        self.request = request
    }
    
    convenience init<T: Encodable>(url: URL, method: HTTPMethod, object: T, header: HTTPHeader = [:]) {
        self.init(url: url, method: method, header: header)
        request.httpBody = try? JSONEncoder().encode(object)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    @discardableResult
    func startRequest<T: Decodable>(completion: ResultCompletion<T>?, endTask: VoidClosure? = nil) -> URLSessionTask {
        let task = Network.defaultSession.dataTask(with: request) { data, response, error in
            defer { endTask?() }
            Log.default("서버 응답: \(self.request.httpMethod ?? "") \(self.request.url?.absoluteString ?? "")")
            do {
                let data = try self.validate(data: data, response: response, error: error)
                let serverData = try JSONDecoder().decode(ServerResponse<T>.self, from: data)
                let validatedData = try serverData.validate(data: data)
                
                completion?(.success(validatedData))
            } catch {
                completion?(.failure(error))
            }
        }
        task.resume()
        Log.default("서버 요청: \(self.request.httpMethod ?? "") \(self.request.url?.absoluteString ?? "")")
        return task
    }
    
    func startBackgroundRequest<T: Decodable>(completion: ResultCompletion<T>? = nil) {
        let task = self.startRequest(completion: completion) { [weak self] in self?.endBackgroundTask() }
        let name = "\(Date()) \(self.request.httpMethod ?? "") \(self.request.url?.absoluteString ?? "")"
        self.startBackgroundTask(name: name) { task.cancel() }
    }
    
    private func validate(data: Data?, response: URLResponse?, error: Error?) throws -> Data {
        if let error = error {
            throw error
        }
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.networkResponseNotExist
        }
        
        guard (200..<300).contains(response.statusCode) else {
            throw NetworkError.networkingFailed(statusCode: response.statusCode)
        }
        
        guard let data = data else {
            throw NetworkError.networkDataNotExist
        }
        
        return data
    }
}
