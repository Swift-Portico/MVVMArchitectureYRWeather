//
//  WeatherForecastModel.swift
//  YRWeatherAppDemo
//
//  Created by Pradeep's Macbook on 07/10/21.
//

import UIKit

struct WeatherForecast: Decodable, Hashable {
    var type: String?
    var properties: Properties?
}

struct Properties: Decodable, Hashable {
    var meta: Meta?
    var timeseries: [TimeSeries]?
}

struct Meta: Decodable, Hashable {
    var updated_at: String?
    var units: Units?
}

struct Units: Decodable, Hashable {
    var wind_speed: String?
}

struct TimeSeries: Decodable, Hashable{
    var data: Data?
    var time: String?
}

struct Data: Decodable, Hashable {
    var next_12_hours: TwelveHours?
    private enum CodingKeys: String, CodingKey { case next_12_hours}
}

struct TwelveHours: Decodable, Hashable {
    var summary: Summary?
}

struct Summary: Decodable, Hashable {
    var symbol_code: String?
    private enum CodingKeys: String, CodingKey { case symbol_code}
}
