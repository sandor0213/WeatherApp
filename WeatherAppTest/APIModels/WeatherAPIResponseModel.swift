//
//  WeatherAPIResponseModel.swift
//  WeatherAppTest
//
//  Created by Shandor Baloh on 01.03.2023.
//

import Foundation

struct WeatherAPIResponseModel: Codable {
    let location: Location?
    let forecast: Forecast?
}

struct Location: Codable {
    let name, country: String?
    let localtime: String?

    enum CodingKeys: String, CodingKey {
        case name, country
        case localtime
    }
}

struct Forecast: Codable {
    let forecastday: [Forecastday]?
}

struct Forecastday: Codable {
    let date: String?
    let day: Day?

    enum CodingKeys: String, CodingKey {
        case date
        case day
    }
}

struct Day: Codable {
    let maxtempC, mintempC: Double?
    let condition: Condition?

    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case mintempC = "mintemp_c"
        case condition
    }
}

struct Condition: Codable {
    let icon: String?
}
