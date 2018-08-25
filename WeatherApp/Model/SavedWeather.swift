//
//  SavedWeather.swift
//  WeatherApp
//
//  Created by Nikita Kechinov on 22.08.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import UIKit
import CoreData


class SavedWeather: NSManagedObject {

    
    
    class func fetchWeather(in context: NSManagedObjectContext, completionHandler: @escaping(([SavedWeather]) -> ())) {
        
        context.perform {
            let request: NSFetchRequest<SavedWeather> = SavedWeather.fetchRequest()
            
            do {
                let result = try context.fetch(request)
                print("Weather is saved in CoreData")
                completionHandler(result)
            } catch {
                print(error)
            }
        }
    }
    
    
    
    class func saveWeather(with weather: Weather, for city: String, in context: NSManagedObjectContext) {
        let weatherToBeSaved = SavedWeather(context: context)
        weatherToBeSaved.city = city
        weatherToBeSaved.date = Date()
        weatherToBeSaved.pressure = weather.pressure
        weatherToBeSaved.temperature = weather.temperature
        weatherToBeSaved.humidity = weather.humidity
        weatherToBeSaved.wind = weather.wind
        weatherToBeSaved.weatherKeyword = weather.weatherType.weatherKeyword
        
        do {
            try context.save()
            print("Weather is saved!")
        } catch {
            print(error)
        }
    }
    
}
