//
//  SearchFilter.swift
//  WeatherApp
//
//  Created by Nikita Kechinov on 22.08.2018.
//  Copyright © 2018 Nikita Kechinov. All rights reserved.
//

import Foundation


struct SearchFilter {
    var cityKeyword: String?
    var keywords: [String]?
    var startDate: Date?
    var endDate: Date?
    
    init?(cityKeyword: String?, addedKeywords: [String: Int], startDate: Date?, endDate: Date?) {
        if cityKeyword == nil && addedKeywords.isEmpty && startDate == nil && endDate == nil {
            return nil
        }
        self.cityKeyword = (cityKeyword != nil ? cityKeyword : nil)
        self.startDate = (startDate != nil ? startDate : nil)
        self.endDate = (endDate != nil ? endDate : nil)
        
        guard !addedKeywords.isEmpty else { return }
        var tempKeyword: [String] = []
        for (key, _) in addedKeywords {
            tempKeyword.append(key)
        }
        self.keywords = tempKeyword
    }
    
    
}
