//
//  Enum.swift
//  YRWeatherAppDemo
//
//  Created by Pradeep's Macbook on 07/10/21.
//

import UIKit

enum WeatherIconOptions: String {
    
    case clearskyDay    = "clearsky_day"
    case clearskyNight  = "clearsky_night"
    case fairDay        = "fair_day"
    case fairNight      = "fair_night"
    case lightrain      = "lightrain"
    case cloudy         = "cloudy"
    case rain           = "rain"
    
    func getWeatherIcon() -> UIImage? {
        switch self {
        case .clearskyDay:
            return UIImage.init(systemName: "sun.max.fill")
        case .clearskyNight:
            return UIImage.init(systemName: "moon.stars.fill")
        case .fairDay:
            return UIImage.init(systemName: "sun.haze.fill")
        case .fairNight:
            return UIImage.init(systemName: "moon.fill")
        case .lightrain:
            return UIImage.init(systemName: "cloud.drizzle.fill")
        case .cloudy:
            return UIImage.init(systemName: "cloud.fill")
        case .rain:
            return UIImage.init(systemName: "cloud.rain.fill")
        }
    }
}
