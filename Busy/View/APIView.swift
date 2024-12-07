

import SwiftUI

struct APIView: View {
    
    @StateObject var locationManager = LocationManagerPlace()
    @State private var weather: WeatherData?
    var body: some View {
        VStack {
            HStack(alignment: .top){
                
                
                
                VStack(alignment: .leading) {
                    HStack(alignment: .top){
                        
                    /*
                        HStack {
                            Image(systemName: "stopwatch.fill").foregroundStyle(.orange)
                            Text("Today").font(.system(size: 15)).fontWeight(.bold)
                        }
                        */
                        
                        HStack {
                            Image(systemName: "stopwatch.fill").foregroundStyle(.orange)
                            Text(Date.now, format: .dateTime).font(.system(size: 13)).font(.caption).fontWeight(.medium)
                        }
                    }
                    
                    HStack {
                        Text("Toomorrow").font(.system(size: 14)).fontWeight(.medium)
                        Image(systemName: "cloud.sun.fill").foregroundStyle(.orange)
                    }
                        
                        HStack{
                            Text("\(Int(weather?.hourly.temperature_2m[38] ?? 0)) \(weather?.current_units.temperature_2m ?? "-")").font(.system(size: 14))
                                
                            Text("Day").font(.system(size: 12))
                                
                        }
                        HStack{
                            Text("\(Int(weather?.hourly.temperature_2m[52] ?? 0)) \(weather?.current_units.temperature_2m ?? "-")").font(.system(size: 14))
                               
                            Text("Night").font(.system(size: 12))
                                
                        }
                        HStack{
                            Text("Maximum wind speed").font(.system(size: 10))
                               
                               
                            Text("\(Int(weather?.hourly.wind_speed_10m[38] ?? 0)) m/s").font(.system(size: 12)).font(.caption).fontWeight(.medium)
                                
                        }
                }
               
                Spacer()
                HStack(alignment: .top){
                    Image(systemName: "location.circle.fill").foregroundStyle(.orange)
                    
                    VStack(alignment: .leading){
                        
                        
                        
                            Text("\(locationManager.placeName ?? "Location unknown")").font(.system(size: 16)).fontWeight(.medium)
                        
                        
                        
                        
                       
                        Text("\(Int(weather?.current.temperature_2m ?? 0)) \(weather?.current_units.temperature_2m ?? "-")").fontWeight(.medium)
                        
                        HStack{
                            Text("Maximum wind speed")
                                .font(.system(size: 11))
                                .font(.caption)
                                
                            Text("\(formattedValue(weather?.current.wind_speed_10m ?? 0)) m/s").font(.system(size: 12)).font(.caption).fontWeight(.medium)
                        }
                        
                    }
                    
                    
                }
               
            }
            
            
        }
        
        .onAppear{
            Task{
                
                do{
                    let response = try await WeatherAPIManager.shared.fetchWeather(latitude: locationManager.loca?.latitude ?? 10, longitude: locationManager.loca?.longitude ?? 10)
                    self.weather = response
                }catch{
                    
                }
                
            }
        }
       
        
        
        
    }
    
    func formattedValue(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
    
}

#Preview {
    APIView()
}



