//
//  Bundle+.swift
//  Diary
//
//  Created by minsong kim on 2023/09/14.
//

import Foundation

extension Bundle {
    var openWeatherApiKey: String {
        guard let file = self.path(forResource: "OpenWeatherInfo", ofType: "plist") else {
            return ""
        }
        
        guard let resource = NSDictionary(contentsOfFile: file) else {
            return ""
        }
        
        guard let key = resource["API_KEY"] as? String else {
            fatalError("OpenWeatherApiKey error")
        }
        
        return key
    }
}
