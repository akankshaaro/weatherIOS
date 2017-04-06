//
//  WeatherAPI.swift
//  Weather
//
//  Created by Akanksha on 4/5/17.
//  Copyright © 2017 hk_work. All rights reserved.
//

import Foundation

class WeatherAPI
{
    var delegate:WeatherAPIDelegate?
    
    //creating a single instance of the class which could be shared across application
    static let sharedInstance : WeatherAPI = {
        let instance = WeatherAPI()
        return instance
        
    }()
    
    func getWeatherInfo(cityName:String)
    {
        let city = cityName.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlHostAllowed)
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: "\(Constant.weatherUrl)\(city ?? "")&APPID=\(Constant.appIdkey)")!
        
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
                self.delegate?.updateWeatherInfo(weatherInfo:nil,errorMsg:"Error occured while retriving the data")
                
            } else {
                
                do {
                    
                    if let data = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    {
                        //look for the error
                        let code = data["cod"] as? String
                        let message = data["message"] as? String
                        if code != nil
                        {
                            print(code ?? "Error code not specified")
                            print(message ?? "Error code not specified")
                            self.delegate?.updateWeatherInfo(weatherInfo:nil,errorMsg:message ?? "Something went wrong")
                        }
                        else
                        {
                            let coord = data["coord"] as! [String:Any]
                            let long = coord["lon"] as! Double
                            let lat = coord["lat"] as! Double
                            
                            let weather = (data["weather"] as! NSArray)[0] as! [String:Any]
                            let desc = weather["description"] as! String
                            let icon = weather["icon"] as! String
                            
                            
                            let main = data["main"] as! [String:Any]
                            let temp = main["temp"] as! Double
                            let humidity = main["humidity"] as! Double
                            let tempMax = main["temp_max"] as! Double
                            let tempMin = main["temp_min"] as! Double
                            
                            let wind = data["wind"] as! [String:Any]
                            let windSpeed = wind["speed"] as! Double
                            
                            let name = data["name"] as! String
                            let sys = data["sys"] as! [String:Any]
                            let country = sys["country"] as! String
                            let sunrise = sys["sunrise"] as! Int64
                            let sunset = sys["sunset"] as! Int64
                            
                            let wthrInfo = WeatherInfo(temp: temp, desc: desc, long: long, lat: lat, windSpeed: windSpeed, cityName: name,icon:icon,humidity:humidity,minTemp:tempMin, maxTemp:tempMax, countryName:country,sunriseTime:sunrise,sunsetTime:sunset)
                            
                            self.delegate?.updateWeatherInfo(weatherInfo:wthrInfo,errorMsg:nil)
                        }
                    }
                    
                } catch {
                    
                    self.delegate?.updateWeatherInfo(weatherInfo:nil,errorMsg:"Error occured while retriving the data")
                    
                }
                
                
            }
            
        })
        task.resume()
        
    }
    
}

