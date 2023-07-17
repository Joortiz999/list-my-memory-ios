//
//  DateComponents.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 5/4/23.
//

import Foundation

extension Date {
    
    func daytoString(format: String = "dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func dateAndTimetoString(format: String = "MMM d, h:mm a") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func timeIn24HourFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    func startOfMonth() -> Date {
        var components = Calendar.current.dateComponents([.year,.month], from: self)
        components.day = 1
        let firstDateOfMonth: Date = Calendar.current.date(from: components)!
        return firstDateOfMonth
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }

    func nextDate(by: Int) -> Date {
        let nextDate = Calendar.current.date(byAdding: .day, value: by, to: self)
        return nextDate ?? Date()
    }
    
    func nextDate() -> Date {
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: self)
        return nextDate ?? Date()
    }
    
    func previousDate() -> Date {
        let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: self)
        return previousDate ?? Date()
    }
    
    func addMonths(numberOfMonths: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .month, value: numberOfMonths, to: self)
        return endDate ?? Date()
    }
    
    func removeMonths(numberOfMonths: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .month, value: -numberOfMonths, to: self)
        return endDate ?? Date()
    }
    
    func removeYears(numberOfYears: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .year, value: -numberOfYears, to: self)
        return endDate ?? Date()
    }
    
    func getHumanReadableDayString() -> String {
        let weekdays = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday"
        ]
        
        let calendar = Calendar.current.component(.weekday, from: self)
        return weekdays[calendar - 1]
    }
    
    func time(since fromDate: Date) -> String {
            let earliest = self < fromDate ? self : fromDate
            let latest = (earliest == self) ? fromDate : self

            let allComponents: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
            let components:DateComponents = Calendar.current.dateComponents(allComponents, from: earliest, to: latest)
            let year = components.year  ?? 0
            let month = components.month  ?? 0
            let week = components.weekOfYear  ?? 0
            let day = components.day ?? 0
            let hour = components.hour ?? 0
            let minute = components.minute ?? 0
            let second = components.second ?? 0

            let descendingComponents = ["year": year, "month": month, "week": week, "day": day, "hour": hour, "minute": minute, "second": second]
            for (period, timeAgo) in descendingComponents {
                if timeAgo > 0 {
                    return "\(timeAgo.of(period)) ago"
                }
            }

            return "Just now"
        }
}
