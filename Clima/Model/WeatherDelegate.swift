//
//  WeatherDelegate.swift
//  Clima
//
//  Created by Fadil Kurniawan on 21/05/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation


protocol WeatherDelegate {
    func didUpdateWeather(_ weatherManager:WeaterManager, data : WeatherModel?)
    func didFailWithError(_ error:Error)
}
