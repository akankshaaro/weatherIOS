//
//  WeatherAPIProtocol.swift
//  Weather
//
//  Created by Akanksha on 4/6/17.
//  Copyright © 2017 hk_work. All rights reserved.
//

import Foundation

protocol WeatherAPIDelegate
{
    func updateWeatherInfo(weatherInfo:WeatherInfo?, errorMsg:String?)
}
