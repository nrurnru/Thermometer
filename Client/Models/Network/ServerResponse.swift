import Foundation

struct ServerResponse<T: Decodable>: Decodable {
    let data: T?
    let error: ServerError?
    
    func validate(data: Data) throws -> T {
        if let error = self.error {
            throw error
        }
        
        guard let data = self.data else {
            throw NetworkError.serverDataNotExist
        }
        
        return data
    }
}
