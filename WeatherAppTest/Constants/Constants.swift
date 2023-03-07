//
//  Constants.swift
//  WeatherAppTest
//
//  Created by Shandor Baloh on 01.03.2023.
//

import Foundation

struct Constants {
    static let apiKey = "522db6a157a748e2996212343221502"
    static let apiProtocol = "https://"
    static let apiBase = "api.weatherapi.com/"
    static let apiVersion = "v1/"
    static let baseURL = apiProtocol + apiBase + apiVersion
    static let forecastPath = "forecast.json"
}
