//
//  Weather.swift
//  WeatherApp
//
//  Created by Nikita Kechinov on 21.08.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import Foundation


enum WeatherType: String {
    case sun        = "sun.jpg"
    case rain       = "rain.jpg"
    case snow       = "snow.jpg"
    case fog        = "fog.jpeg"
    case cloud      = "cloudy.jpg"
    case night      = "night.jpg"
    case unknown    = "unknown"
    
    var corespondingImageName: String {
        return self.rawValue
    }
    var weatherKeyword: String {
        guard self.corespondingImageName != "unknown" else {
            return "unknown"
        }
        let stringToBeCut = self.corespondingImageName
        let index = stringToBeCut.range(of: ".")!.lowerBound
        return String(stringToBeCut.prefix(upTo: index))
    }
}


struct Weather {
    let temperature: Double
    let humidity: Double
    let pressure: Double
    let wind: Double
    let weatherIcon: String
}





protocol SavedWeatherConverting {
    func convertingToSavedWeather() -> SavedWeather?
}




extension Weather: SavedWeatherConverting {
    
    func convertingToSavedWeather() -> SavedWeather? {
        var savedWeather: SavedWeather?
        savedWeather?.humidity = self.humidity
        savedWeather?.pressure = self.pressure
        savedWeather?.temperature = self.temperature
        savedWeather?.wind = self.wind
        savedWeather?.weatherKeyword = self.weatherType.weatherKeyword
        return savedWeather
    }
}



extension Weather {
    var pressureString: String {
        return "\(pressure) mm"
    }
    
    var humidityString: String {
        return "\(humidity) %"
    }
    
    var temperatureString: String {
        return "\(temperature)˚C"
    }
    
    var windString: String {
        return "\(wind) m/s"
    }
    
    var weatherType: WeatherType {
        switch self.weatherIcon {
        case "clear-day": return .sun
        case "clear-night", "partly-cloudy-night": return .night
        case "fog": return .fog
        case "cloudy", "partly-cloudy-day": return .cloud
        case "sleet", "snow": return .snow
        case "rain": return .rain
        default: return .unknown
            
        }
    }
    
}

