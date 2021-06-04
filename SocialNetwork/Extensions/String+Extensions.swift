//
//  String+Extensions.swift
//  SocialNetwork
//
//  Created by Euler Carvalho on 02/06/21.
//

import Foundation

extension String {
    func date(format: String, dateFormatter: DateFormatter = DateFormatter()) -> Date? {
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "pt-br")
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.date(from: self)
        return date
    }
    
    static func dateToStringByAddingMinutes(format: String? =  "yyyy-MM-dd'T'HH:mm:ssZ", date: Date, amountOfMinutes: Int, calendarComponent: Calendar.Component = .minute) -> String {
        let calendar = Calendar.current
        let dateAddedTime = calendar.date(byAdding: calendarComponent, value: amountOfMinutes, to: date)
        return dateToString(date: dateAddedTime ?? Date())
    }
    
    static func dateToString(format: String? =  "yyyy-MM-dd'T'HH:mm:ssZ", date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: date)
    }
}
