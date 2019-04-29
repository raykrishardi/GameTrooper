//
//  DateExtension.swift
//  GameTrooper
//
//  Created by Ray Krishardi Layadi on 18/4/17.
//  Copyright © 2017 Ray Krishardi Layadi. All rights reserved.
//

import Foundation

//-------------------------------------------------------------------------------------------------------------------------------
//                                                            Source:
//    http://stackoverflow.com/questions/27310883/swift-ios-doesrelativedateformatting-have-different-values-besides-today-and
//                                                              By:
//                                                          "Leo Dabus"
//-------------------------------------------------------------------------------------------------------------------------------

// Source code directly obtained from Stack Overflow user "Leo Dabus"
// Manages the conversion from ISO8601 date format (e.g. "2017-06-07T09:32:08Z") to relative time format (e.g. "4 hours ago") for the game news section 
extension Date {
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    var relativeTime: String {
        let now = Date()
        if now.years(from: self)   > 0 {
            return now.years(from: self).description  + " year"  + { return now.years(from: self)   > 1 ? "s" : "" }() + " ago"
        }
        if now.months(from: self)  > 0 {
            return now.months(from: self).description + " month" + { return now.months(from: self)  > 1 ? "s" : "" }() + " ago"
        }
        if now.weeks(from:self)   > 0 {
            return now.weeks(from: self).description  + " week"  + { return now.weeks(from: self)   > 1 ? "s" : "" }() + " ago"
        }
        if now.days(from: self)    > 0 {
            if now.days(from:self) == 1 { return "Yesterday" }
            return now.days(from: self).description + " days ago"
        }
        if now.hours(from: self)   > 0 {
            return "\(now.hours(from: self)) hour"     + { return now.hours(from: self)   > 1 ? "s" : "" }() + " ago"
        }
        if now.minutes(from: self) > 0 {
            return "\(now.minutes(from: self)) minute" + { return now.minutes(from: self) > 1 ? "s" : "" }() + " ago"
        }
        if now.seconds(from: self) > 0 {
            if now.seconds(from: self) < 15 { return "Just now"  }
            return "\(now.seconds(from: self)) second" + { return now.seconds(from: self) > 1 ? "s" : "" }() + " ago"
        }
        return ""
    }
}

//-------------------------------------------------------------------------------------------------------------------------------
