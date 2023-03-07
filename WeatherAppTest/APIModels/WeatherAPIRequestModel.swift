//
//  WeatherAPIRequestModel.swift
//  WeatherAppTest
//
//  Created by Shandor Baloh on 02.03.2023.
//

import Foundation

struct WeatherAPIRequestModel: Encodable {
    let key: String?
    let q: String?
    let days: Int?
    let aqi: String?
    let alerts: String?
}
