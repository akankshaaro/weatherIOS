//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Akanksha on 4/5/17.
//  Copyright © 2017 hk_work. All rights reserved.
//

import XCTest

@testable import Weather

class WeatherTests: XCTestCase {
    
    var wthrAPI:WeatherAPI?
    
    override func setUp() {
        super.setUp()
        wthrAPI = WeatherAPI.sharedInstance
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func testWeatherAPIInstance()
    {
        XCTAssertNotNil(wthrAPI, "weather api instance successfully get created")
    }
    
    func testUpdateWeatherInfo()
    {
        let wthrInfo:WeatherInfo = WeatherInfo(temp: 1.22, desc: "Rainy", long: 1.29, lat: 10.11, windSpeed: 12, cityName: "Ohio", icon: "10d", humidity: 60, minTemp: 12, maxTemp: 18, countryName: "US", sunriseTime: 1232323, sunsetTime: 121313131)
        XCTAssertNotNil(wthrInfo, "Weather Info model get sucessfully initialized")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //test written to check the web service call
    func testAsynchronousWebAPICall() {
        
        let city = "ohio"
        let url = URL(string: "http://samples.openweathermap.org/data/2.5/weather?q=\(city)&appid=b16bc5e45c8e0599ccfac3431533c601")!
        let urlExpectation = expectation(description: "fetch Data from \(url)")
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            XCTAssertNotNil(data, "data should not be nil")
            XCTAssertNil(error, "error should be nil")
            urlExpectation.fulfill()
        }
        
        task.resume()
        
        waitForExpectations(timeout: task.originalRequest!.timeoutInterval) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            task.cancel()
        }
    }
    
}
