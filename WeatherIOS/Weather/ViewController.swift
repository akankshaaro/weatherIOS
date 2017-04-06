//
//  ViewController.swift
//  Weather
//
//  Created by Akanksha on 4/5/17.
//  Copyright © 2017 hk_work. All rights reserved.
//

import UIKit

class ViewController: UIViewController, WeatherAPIDelegate, UISearchBarDelegate {

    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var tempDescLbl: UILabel!
    @IBOutlet weak var humidLbl: UILabel!
    @IBOutlet weak var windLbl: UILabel!
    @IBOutlet weak var wthrImage: UIImageView!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var wthrSearchBar: UISearchBar!
    @IBOutlet weak var tempMax: UILabel!
    @IBOutlet weak var tempMin: UILabel!
    @IBOutlet weak var windHumidStackView: UIStackView!
    @IBOutlet weak var tempStackView: UIStackView!
    @IBOutlet weak var timeStampInfo: UILabel!
    @IBOutlet weak var sunRiseSetStackView: UIStackView!
    @IBOutlet weak var sunriseLbl: UILabel!
    @IBOutlet weak var sunsetLbl: UILabel!
    
    
    var lastSearchedCity:String = ""
    var timerAPI:Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wthrSearchBar.delegate = self
        lookForLastSeachedCityData()
        
        //Load cities data to call the API from City ID
        //loadCityListJSON()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        wthrSearchBar.endEditing(true)
    }
    
    //Mark:Look for data of last seached city
    func lookForLastSeachedCityData() {
        if let lastCity = UserDefaults.standard.value(forKey: "lastSearchedCity")
        {
            getWeatherInfo(city: lastCity as! String)
        }
        else
        {
            updateWeatherViewWithMsg(msg: "Look for the Weather", isErrorOcurred:false)
        }
    }
    //MARK: Timer functions call
    //Schedule a timer for updating the weather data on fixed intervals
    func scheduleTimer()
    {
        timerAPI =
        Timer.scheduledTimer(timeInterval: 600,
                             target: self,
                             selector: #selector(self.updateWeatherDetails),
                             userInfo: nil,
                             repeats: true)
        
    }
    
    func updateWeatherDetails()
    {
        getWeatherInfo(city: lastSearchedCity)
    }

    //MARK: Searchbar delagate 
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        getWeatherInfo(city: searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    //MARK: update weather data on UI
    func  updateWeatherView(weatherInfo:WeatherInfo) {
        //Country check
        if(weatherInfo.countryName == "US")
        {
            self.tempLbl.text = String(format: "%.2f", weatherInfo.temp - 273.15) + "°"
            self.tempDescLbl.text = weatherInfo.desc
            self.humidLbl.text = String(format: "%.2f", weatherInfo.humidity) + " %"
            self.windLbl.text = String(format: "%.2f", weatherInfo.windSpeed) + " mps"
            self.cityLbl.text = weatherInfo.cityName + ", " + weatherInfo.countryName
            let maxTemp = weatherInfo.maxTemp - 273.15
            let minTemp = weatherInfo.minTemp - 273.15
            self.tempMax.text = String(format: "H %.2f°", maxTemp)
            self.tempMin.text = String(format: "L %.2f°", minTemp)
            self.wthrImage.downloadImage(imgName: weatherInfo.icon)
            self.tempStackView.isHidden = false
            self.sunRiseSetStackView.isHidden = false
            self.windHumidStackView.isHidden = false
            self.sunriseLbl.text = weatherInfo.sunrise
            self.sunsetLbl.text = weatherInfo.sunset
            scheduleTimer()
            UserDefaults.standard.setValue(lastSearchedCity, forKey: "lastSearchedCity")
        }
        else
        {
            updateWeatherViewWithMsg(msg: "Please enter valid US city", isErrorOcurred: false)
            
        }
    }
    
    func  updateWeatherViewWithMsg(msg:String, isErrorOcurred:Bool) {
        
        self.tempLbl.text = ""
        self.tempDescLbl.text = msg
        self.tempStackView.isHidden = true
        self.windHumidStackView.isHidden = true
        self.sunRiseSetStackView.isHidden = true
        self.cityLbl.text = ""
        self.wthrImage.image = isErrorOcurred ? UIImage(named: "alert") : UIImage(named: "weather")
        self.timeStampInfo.text = ""
        UserDefaults.standard.removeObject(forKey: "lastSearchedCity")
        lastSearchedCity = ""
    }
    
    //MARK: get weather data
    func getWeatherInfo(city:String)
    {
        lastSearchedCity = city
        let wthrAPI = WeatherAPI.sharedInstance
        wthrAPI.delegate = self
        wthrAPI.getWeatherInfo(cityName: city)
        
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
        self.timeStampInfo.text = "Updated at \(timestamp)"
    }
    
    //Refesh button get clicked
    @IBAction func refreshBtnClicked(_ sender: Any) {
        guard lastSearchedCity == "" else
        {
            let wthrAPI = WeatherAPI.sharedInstance //shared instance
            wthrAPI.delegate = self
            wthrAPI.getWeatherInfo(cityName: lastSearchedCity)
            timerAPI?.invalidate()
            scheduleTimer()
            return
        }
        
         self.updateWeatherViewWithMsg(msg: "Enter city name", isErrorOcurred:false)
    }
    
    //MARK: WeatherAPI delagate
    func updateWeatherInfo(weatherInfo wthrInfo:WeatherInfo?, errorMsg:String?)
    {
        if errorMsg == nil
        {
            //update UI on main thread
            DispatchQueue.main.async {
                self.updateWeatherView(weatherInfo: (wthrInfo)!)
            }
        }
        else
        {
            //update UI on main thread
            DispatchQueue.main.async {
                self.updateWeatherViewWithMsg(msg: errorMsg!, isErrorOcurred:true)
            }
        }
    }
    
    
    //MARK: loading json file to look for the the city ID
    /*func loadCityListJSON()
    {
     
        DispatchQueue.global().async {
            if let path = Bundle.main.path(forResource: "city_List", ofType: "json") {
                
                let url = URL(fileURLWithPath: path)
                do {
                    
                    let data = try Data(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
                    
                    do {
                        // error while parsing the json format issue
                        //deleted json file from project due to its huge size
                        ////to do
                        }
                    } catch {
                        print("error1: \(error)")
                    }
                    
                } catch {
                    print("error2: \(error)")
                }
            }
        }
    }*/
}

