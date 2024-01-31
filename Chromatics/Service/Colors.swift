import Foundation

protocol ColorServiceProtocol {
    func generateColorPalette(completion: @escaping (Result<[ColorModel], Error>) -> Void)
}

class ColorService: ColorServiceProtocol {
    static let shared = ColorService()
    
    private let baseURLString = "https://x-colors.yurace.pro/api/random?number=5&type=dark"
    
    func generateColorPalette(completion: @escaping (Result<[ColorModel], Error>) -> Void) {
        let url = URL(string: baseURLString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                completion(.failure(NSError(domain: "Invalid Response", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let colorDataArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: String]]
                
                print("Received color data array: \(String(describing: colorDataArray))")
                
                let colorModels = colorDataArray?.compactMap { data in
                    return ColorModel(data: data)
                }
                
                if let colorModels = colorModels, !colorModels.isEmpty {
                    completion(.success(colorModels))
                } else {
                    completion(.failure(NSError(domain: "Invalid Data", code: 0, userInfo: nil)))
                }
            } catch {
                print("Error parsing JSON: \(error)")
                completion(.failure(error))
            }

        }
        
        dataTask.resume()
    }
}
