
import Foundation

struct WeatherData: Decodable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let elevation: Double
    let current_units: CurrentUnits
    let current: Current
    let hourly_units: HourlyUnits
    let hourly: Hourly
    
    struct CurrentUnits: Decodable {
        let time: String
        let interval: String
        let temperature_2m: String
        let wind_speed_10m: String
    }
    struct Current: Decodable{
        let time: String
       let interval: Int
        let temperature_2m: Double
        let wind_speed_10m: Double
    }
    struct HourlyUnits: Decodable {
        let time: String
        let temperature_2m:String
        let relative_humidity_2m: String
        let wind_speed_10m: String
    }
    struct Hourly: Decodable {
        let time: [String]
        let temperature_2m: [Double]
        let relative_humidity_2m: [Int]
        let wind_speed_10m: [Double]
    }
}

extension WeatherData{
    static func placeholder() -> WeatherData{
        WeatherData(latitude: 0.0, longitude: 0.0, timezone: "", elevation: 1.1, current_units: CurrentUnits(time: "", interval: "", temperature_2m: "", wind_speed_10m: ""), current: Current(time: "", interval: 0, temperature_2m: 0, wind_speed_10m: 0), hourly_units: HourlyUnits(time: "", temperature_2m: "", relative_humidity_2m: "", wind_speed_10m: ""), hourly: Hourly(time: ["",""], temperature_2m: [0.0, 0.0], relative_humidity_2m: [0, 0], wind_speed_10m: [0.0, 0.0]))
    }
}


