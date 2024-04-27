//
//  LocationManager.swift
//  OnlineStore
//
//  Created by Polina on 25.04.2024.
//

import Foundation
import CoreLocation

enum CurrencyType{
    case usa, russia, europe
}

class LocationManager: NSObject {
    static let shared = LocationManager()
    var currency: CurrencyType?
    
    private override init() {}
    
    private let europeanCountries = ["France", "Франция", "Germany", "Германия", "Italy", "Италия", "Spain", "Испания", "United Kingdom", "Великобритания", "Ireland", "Ирландия", "Poland", "Польша", "Netherlands", "Недерланды",  "Belgium", "Бельгия", "Austria", "Австрия", "Switzerland", "Швейцария", "Denmark", "Дания", "Norway", "Норвегия", "Sweden", "Швеция", "Finland", "Финляндия", "Portugal", "Португалия", "Greece", "Греция",  "Czech Republic", "Чехия", "Hungary", "Венгрия", "Slovakia", "Словакия",  "Serbia", "Сербия", "Montenegro", "Черногория",  "Bulgaria", "Болгария"]
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()

    func getUserLocation() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
    }

    private func choseContinent(for country: String) -> CurrencyType {
        switch country {
        case "Russia", "Россия":
            return .russia
        case "United States", "Соединённые Штаты Америки":
            return .usa
        default:
            let currencyType = europeanCountries.contains(country) ? CurrencyType.europe : CurrencyType.usa
            return currencyType
        }
    }
}
// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            geocoder.reverseGeocodeLocation(location) { (placemarks, _) in
                if let placemark = placemarks?.first {
                    guard let country = placemark.country else { return }
                    print(placemark)
                    let currencyType = self.choseContinent(for: country)
                    self.currency = currencyType
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}


