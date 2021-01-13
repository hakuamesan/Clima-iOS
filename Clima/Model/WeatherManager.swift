/*
 
 Author: Ananth
 Date: 13 Jan 2020
 
 */


import Foundation
import UIKit

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
}



struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=103e41e1f9fdd4e18a872b70f4a1c251&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
        
        performRequest(urlString: urlString)
    }
    
    
    func performRequest(urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    print(error)
                    return
                }
                
                if let safeData = data {
                    if let weather =  self.parseJSON(weatherData: safeData){
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            task.resume()
            
        }
    }


    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
          let  decoderData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let name = decoderData.name
            let t = decoderData.main.temp
            //let description = decoderData.weather[0].description
            let id = decoderData.weather[0].id
            
            let weather = WeatherModel(conditionId:id, cityName: name, temp: t)
            //print(weather.conditionName)
            //print(weather.tempString)
            //print(description)
            
            return weather
        } catch {
            print(error)
            return nil
        }
    }
    
   

}
