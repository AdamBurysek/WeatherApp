//
//  Model.swift
//  WeatherApp
//
//  Created by Adam Buryšek on 17.07.2024.
//

import Foundation

struct WeatherResponse: Codable {
    let properties: Properties
}

struct Properties: Codable {
    let timeseries: [Timeseries]
}

struct Timeseries: Codable {
    let time: String
    let data: DataClass
}

struct DataClass: Codable {
    let instant: Instant
    let next_1_hours: NextHours?
    let next_6_hours: NextHours?
}

struct Instant: Codable {
    let details: Details
}

struct Details: Codable {
    let airTemperature: Double
    
    enum CodingKeys: String, CodingKey {
        case airTemperature = "air_temperature"
    }
}

struct NextHours: Codable {
    let summary: Summary
    let details: PrecipitationDetails?
}

struct Summary: Codable {
    let symbolCode: String
    
    enum CodingKeys: String, CodingKey {
        case symbolCode = "symbol_code"
    }
}

struct PrecipitationDetails: Codable {
    let precipitationAmount: Double?
    
    enum CodingKeys: String, CodingKey {
        case precipitationAmount = "precipitation_amount"
    }
}
