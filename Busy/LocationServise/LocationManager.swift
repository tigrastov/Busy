
import CoreLocation
import SwiftUI

class LocationManagerPlace: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManagerPlace()
    
    private var locationManager = CLLocationManager()
    @Published var loca: CLLocationCoordinate2D?
    
//    @AppStorage("latitude") var latitude: Double = 1.1
//    @AppStorage("longitude") var longitude: Double = 1.1
    
   // @State var latitude: Double = UserDefaults.standard.double(forKey: "latitude")
   // @State var longitude: Double = UserDefaults.standard.double(forKey: "longitude")
    
    
    @Published var placeName: String? = ""

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
/*
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.first else { return }
            self.latitude = location.coordinate.latitude
        UserDefaults.standard.set(latitude, forKey: "latitude")
            self.longitude = location.coordinate.longitude
        UserDefaults.standard.set(longitude, forKey: "longitude")
  */
        
            func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                guard let location = locations.first else { return }
                self.loca = location.coordinate
         
        
        
        
        
        // Определяем название населенного пункта
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemark = placemarks?.first {
                self.placeName = placemark.locality ?? "Неизвестно"
            }
        }
       
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}


