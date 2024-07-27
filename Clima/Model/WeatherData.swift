//
//  WeatherData.swift
//  Clima
//
//  Created by Ashfak Ahamed on 25/02/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

//codable = combination of Encodable and Decodable
struct WeatherData: Codable{
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable{
    let temp: Double
}

struct Weather: Codable{
    let description: String
    let id: Int
}
