//
//  WeatherManager.swift
//  Clima
//
//  Created by Ashfak Ahamed on 25/02/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

// We create the protocols in the same file where it is going to be used. This is the convention
protocol WeatherViewManagerDelegate{
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=2f7bd3f0be74047c994d1782a2e446ef&units=metric"
    var delegate: WeatherViewManagerDelegate?
    
    func fetchWeather(cityName: String){
        
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    
    
    func performRequest(with urlString: String){
        
        //1. Create a URL
        if let url = URL(string: urlString){
            
            //2. Create a URL session
            let session = URLSession(configuration: .default)
            
            //3. Give session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    
                    //                    let dataString = String(data: safeData, encoding: .utf8)
                    //                    print(dataString!)
                    
                    //                    Here self reference is required because this function call is happening within a closure
                    if let weather = self.parseJSON(safeData){
                        
                        self.delegate?.didUpdateWeather(self, weather: weather)
                        
                    }
                    
                }
            }
            
            //4. Start the task
            task.resume()
            
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do{
            
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let cityName = decodedData.name
            let temperature = decodedData.main.temp
            
            let weather = WeatherModel(conditionId: id, cityName: cityName, temperature: temperature)
            return weather
            
        } catch {
            
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
