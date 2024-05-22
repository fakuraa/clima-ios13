//
//  WeaterManager.swift
//  Clima
//
//  Created by Fadil Kurniawan on 21/05/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation


struct WeaterManager {
    let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    let appId = "ee0204a920ea0eaf80b055e095f3bf9d"
    
    func getBaseURL()->String{return "\(baseURL)?appid=\(appId)&units=metric"}
    
    var delegate: WeatherDelegate?
    
    func callReq(with urlString:String){
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data:Data?, response:URLResponse?,error:Error?) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let weather =  self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, data: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data : Data)->WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self,from: data)
            return WeatherModel(
                conditionId: decodedData.weather.first?.id ?? 0,
                cityName: decodedData.name,
                temperature: decodedData.main.temp
            )
        }catch{
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
    
    
    func fetchWeather(cityName:String){
        let url = "\(getBaseURL())&q=\(cityName)"
        callReq(with: url)
    }
    
    func fetchWeather(lat:Double, lon:Double){
        let url = "\(getBaseURL())&lat=\(lat)&lon=\(lon)"
        callReq(with: url)
    }
}
