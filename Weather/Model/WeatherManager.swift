//
//  WeatherManager.swift
//  Weather
//
//  Created by João Victor on 06/04/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import UIKit

let keys = Keys()

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(keys.API_KEY)&units=metric"
    
    func fetchWeather(_ cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
        
    }
    
    func performRequest(urlString: String) {
        //Criar URL
        if let url = URL(string: urlString){
            //Criar sessão
            let session = URLSession(configuration: .default)
            //Dar uma task pra sessão
            let task = session.dataTask(with: url) { data, response, error in
                
                if let error = error {
                    print(error)
                }
                
                if let safeData = data {
                    parseJSON(weatherData: safeData)
                }
                
            }
            //Iniciar sessão
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data){
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weatherModel = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
        } catch {
            print(error)
        }
    }
    
}
