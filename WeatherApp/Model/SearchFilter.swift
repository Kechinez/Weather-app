//
//  SearchFilter.swift
//  WeatherApp
//
//  Created by Nikita Kechinov on 22.08.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import Foundation


struct FilterOptions: OptionSet {
    let rawValue: Int
    static let valueForInit = FilterOptions(rawValue: 1 << 0)
    static let byCityName = FilterOptions(rawValue: 1 << 1)
    static let byKeywords = FilterOptions(rawValue: 1 << 2)
    static let byDates = FilterOptions(rawValue: 1 << 3)
    static let bySingleDate = FilterOptions(rawValue: 1 << 4)
    
}



struct SearchFilter {
    var cityKeyword: String?
    var keywords: [String]?
    var startDate: Date?
    var endDate: Date?
    var usedOptions: FilterOptions
    
    
    
    init?(cityKeyword: String?, addedKeywords: [String: Int], startDate: Date?, endDate: Date?) {
        if cityKeyword == nil && addedKeywords.isEmpty && startDate == nil && endDate == nil {
            return nil
        }
        self.usedOptions = [.valueForInit]
        if cityKeyword != "" {
            self.cityKeyword = cityKeyword
            self.usedOptions.insert(.byCityName)
        }
        if startDate != nil || endDate != nil {
            self.startDate = (startDate != nil ? startDate : nil)
            self.endDate = (endDate != nil ? endDate : nil)
            let dateOption: FilterOptions = (startDate != nil && endDate != nil ? .byDates : .bySingleDate)
            self.usedOptions.insert(dateOption)
        }
        
        if !addedKeywords.isEmpty {
            var tempKeyword: [String] = []
            for (key, _) in addedKeywords {
                print(key.lowercased())
                tempKeyword.append(key.lowercased())
            }
            self.keywords = tempKeyword
            self.usedOptions.insert(.byKeywords)
        }
    }
    
    
}
