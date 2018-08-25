//
//  CoreDataStack.swift
//  WeatherApp
//
//  Created by Nikita Kechinov on 25.08.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import Foundation
import CoreData



protocol Searching {
    func buildRequestPredicate(for request: NSFetchRequest<SavedWeather>)
    func fetchWeatherHistory()
}
