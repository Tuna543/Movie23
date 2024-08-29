//
//  TimeConverter.swift
//  Movie23
//
//  Created by BS00880 on 1/7/24.
//

import Foundation

func convertMinutesToHoursAndMinutes(minutes: Int) -> String {
    let hours = minutes / 60
    let remainingMinutes = minutes % 60
    
    var result = ""
    if hours > 0 {
        result += "\(hours)H"
    }
    
    if hours > 0 && remainingMinutes > 0 {
        result += " "
    }
    
    if remainingMinutes > 0 {
        result += "\(remainingMinutes)M"
    }
    
    if hours == 0 && remainingMinutes == 0 {
        result = "N/A"
    }
    
    return result
}
