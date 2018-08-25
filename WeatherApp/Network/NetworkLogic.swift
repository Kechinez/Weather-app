//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Nikita Kechinov on 21.08.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import Foundation
import Alamofire



typealias JSON = [String: AnyObject]


enum StringUrls {
    case GoogleMapsGeocoding(cityName: String)
    case DarkSky(coordinates: Coordinates)
    
    var url: String {
        
        switch self {
        case .DarkSky(let coordinates):
            let base = "https://api.darksky.net/"
            let path = "forecast/307d26898aeb937575805a51bf3117e2/\(coordinates.latitude),\(coordinates.longitude)"
            return "\(base)\(path)"
        case .GoogleMapsGeocoding(let cityName):
            let base = "https://maps.googleapis.com/"
            let path = "maps/api/geocode/json?address=\(cityName)&key=AIzaSyAmV1T_J6_noWuMYBJukYv3-eDBvhr3zmY"
            return "\(base)\(path)"
        }
    }
}





protocol Networking {}


extension Networking {
    func requestWeather(in coordinates: Coordinates, completionHandler: @escaping ((Weather?) -> ())) {
        let request = StringUrls.DarkSky(coordinates: coordinates)
        
        print(request.url)
        Alamofire.request(request.url).responseJSON { (jsonResponse) in
            
            guard let retrievedJson = jsonResponse.result.value as? JSON else {
                completionHandler(nil)
                return
            }
            guard let weather = Weather(jsonToBeParsedToWeatherObject: retrievedJson) else {
                completionHandler(nil)
                return
            }
            
            completionHandler(weather)
        }
    }
    
    
    
    func requestTranslationNameToCoordinates(with name: String, completionHandler: @escaping ((Coordinates?) -> ())) {
        
        let request = StringUrls.GoogleMapsGeocoding(cityName: name)
        Alamofire.request(request.url).responseJSON { (jsonResponse) in
            
            guard let retrievedJson = jsonResponse.result.value as? JSON else {
                completionHandler(nil)
                return
            }
            guard let coordinates = Coordinates(jsonToBeParsedToCoordinates: retrievedJson) else {
                completionHandler(nil)
                return
            }
            completionHandler(coordinates)
        }
    }
    
}
