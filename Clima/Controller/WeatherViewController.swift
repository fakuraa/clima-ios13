//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchField: UITextField!
    
    var weatherManager = WeaterManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchField.delegate = self
    }
    
}

// MARK: - SEARCH FIELD
extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPress(_ sender: UIButton) {
        searchField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }else{
            searchField.placeholder = "Type Something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchField.text{
            weatherManager.fetchWeather(cityName: city)
        }
        searchField.text = ""
    }
    
}

//MARK: - DELEGATE
extension WeatherViewController : WeatherDelegate {
    func didUpdateWeather(_ weatherManager:WeaterManager, data: WeatherModel?) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = data?.temperatureString
            self.cityLabel.text = data?.cityName
            self.conditionImageView.image = UIImage(systemName: data?.conditionname ?? "")
        }
    }
    
    func didFailWithError(_ error: Error) {
        print("err : \(error)")
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController : CLLocationManagerDelegate {
    
    @IBAction func gpsPress(_ sender: UIButton){
        locationManager.requestLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            weatherManager.fetchWeather(lat: lat, lon:long)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}
