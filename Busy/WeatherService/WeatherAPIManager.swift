
import Foundation
import CoreLocation

class WeatherAPIManager{
    static let shared = WeatherAPIManager(); private init() {}
    @Published var weatherData: WeatherData?

    
    enum NetworkErros: Error {
     case invalidURL, invalidResponse, invalidData
    }
    
    private func createURL(latitude: Double, longitude: Double) -> URL?{
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m,wind_speed_10m&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m"
        let url = URL(string: urlString)
        return url
    }
    
    func fetchWeather(latitude: Double, longitude: Double)async throws -> WeatherData{
        guard let url = createURL(latitude: latitude, longitude: longitude) else { throw NetworkErros.invalidURL }
        let data = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        //decoder.keyDecodingStrategy = .convertFromSnakeCase
        let response = try decoder.decode(WeatherData.self, from: data.0)
        return response
    }
}

