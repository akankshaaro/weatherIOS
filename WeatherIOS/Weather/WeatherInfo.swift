//
//  WeatherInfo.swift
//  Weather
//
//  Created by Akanksha on 4/5/17.
//  Copyright © 2017 hk_work. All rights reserved.
//

import Foundation
struct WeatherInfo {
    var temp:Double
    var desc:String
    var long:Double
    var lat:Double
    var windSpeed:Double
    var cityName:String
    var countryName:String
    var sunrise:String
    var sunset:String
    var icon:String
    var humidity:Double
    
    var maxTemp:Double
    var minTemp:Double
    
    init(temp:Double, desc:String, long:Double, lat:Double, windSpeed:Double, cityName:String, icon:String, humidity:Double, minTemp:Double, maxTemp:Double,countryName:String,sunriseTime:Int64,sunsetTime:Int64) {
        self.temp = temp
        self.desc = desc
        self.long = long
        self.lat = lat
        self.windSpeed = windSpeed
        self.cityName = cityName
        self.icon = icon
        self.humidity = humidity
        self.maxTemp = maxTemp
        self.minTemp = minTemp
        self.countryName = countryName
        self.sunrise = ""
        self.sunset = ""
        self.sunrise = UTCToLocal(timeVal:sunriseTime)
        self.sunset = UTCToLocal(timeVal:sunsetTime)
    }
    
    //UTC to local time conversion
    func UTCToLocal(timeVal:Int64) -> String
    {
        let date = Date(timeIntervalSince1970: TimeInterval(timeVal))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "hh:mm a"
        let dateString = dayTimePeriodFormatter.string(from: date)
        return dateString
    }
}
