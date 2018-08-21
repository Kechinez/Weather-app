//
//  JsonParsingProtocol.swift
//  WeatherApp
//
//  Created by Nikita Kechinov on 21.08.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import Foundation


protocol ParsingJSON {
    init?(jsonToBeParsedToCoordinates: JSON)
    init?(jsonToBeParsedToWeatherObject: JSON)
}



extension Weather: ParsingJSON {
    
    init?(jsonToBeParsedToCoordinates: JSON) { return nil }
    
    init?(jsonToBeParsedToWeatherObject: JSON) {
        guard let currentWeatherJson = jsonToBeParsedToWeatherObject["currently"] else { return nil }
        guard let temperature = currentWeatherJson["temperature"] as? Double,
            let humidity = currentWeatherJson["humidity"] as? Double,
            let pressure = currentWeatherJson["pressure"] as? Double,
            let wind = currentWeatherJson["windSpeed"] as? Double,
            let icon = currentWeatherJson["icon"] as? String else { return nil }
        
        self.humidity = humidity
        self.pressure = pressure
        self.temperature = temperature
        self.wind = wind
        self.weatherIcon = icon
    }
}



extension Coordinates: ParsingJSON {
    init?(jsonToBeParsedToWeatherObject: JSON) { return nil }
    
    init?(jsonToBeParsedToCoordinates: JSON) {
        
        guard let result = jsonToBeParsedToCoordinates["results"] as? [JSON] else { return nil }
        guard result.count > 0 else { return nil }
        guard let addressComponent = result[0]["address_components"] as? [JSON] else { return nil }
        guard let cityName = addressComponent[0]["long_name"] as? String else { return nil }
        
        guard let geometry = result[0]["geometry"] as? JSON else { return nil }
        guard let location = geometry["location"] as? JSON else { return nil }
        guard let latitude = location["lat"] as? Double,
            let longitude = location["lng"] as? Double else { return nil }
        
        self.latitude = "\(latitude)"
        self.longitude = "\(longitude)"
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: RequestedCityWasUpdatedNotificationKey), object: nil, userInfo: ["value" : cityName])
        
    }
    
}
