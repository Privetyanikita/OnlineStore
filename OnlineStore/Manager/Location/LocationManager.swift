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
    
    private let currencyMapping: [String : CurrencyType] = [
        "₽": .russia,
        "$": .usa,
        "€": .europe,
        "дин.": .europe,
        "den": .europe,
        "L": .europe,
        "kr": .europe,
        "Kč": .europe,
        "₴": .europe,
        "lei": .europe,
        "zł": .europe,
        "Ft": .europe,
        "лв": .europe,
        "Br": .europe,
        "Fr.": .europe,
        "Fr": .europe,
        "£": .europe
    ]
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()

    func getUserLocation() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
    }
    
    private func chooseCurrency(symbol: String) {
        print(symbol)
        currency = currencyMapping[symbol] ?? .usa
        //print("Currency new: \(currency)")
    }
}
// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            geocoder.reverseGeocodeLocation(location) { (placemarks, _) in
                if let placemark = placemarks?.first {
                    guard let country = placemark.country else { return }
                    NetworkManager.shared.fetchCountryCurrency(country: country) { [weak self] result in
                        guard let self else { return }
                        DispatchQueue.main.async {
                            switch result{
                            case .success(let data):
                                let currency = data.first?.currencies.values.first ?? Currency(symbol: "$")
                                self.chooseCurrency(symbol: currency.symbol )
                            case .failure(let error):
                                print("Currency Fetch Error \(error.localizedDescription)")
                            }
                        }
                    }
                    print(placemark)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}


