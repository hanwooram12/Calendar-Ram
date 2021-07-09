//
//  ExDate.swift
//  Calendar-iOS
//
//  Created by 한우람 on 2021/07/09.
//

import Foundation

extension Date {
    var year: Int { return Calendar.current.component(.year, from: self) }
    var month: Int { return Calendar.current.component(.month, from: self) }
    var weekday: Int { return Calendar.current.component(.weekday, from: self) }
    var day: Int { return Calendar.current.component(.day, from: self) }
    var hour: Int { return Calendar.current.component(.hour, from: self) }
    var minute: Int { return Calendar.current.component(.minute, from: self) }
    var second: Int { return Calendar.current.component(.second, from: self) }
    var nanosecond: Int { return Calendar.current.component(.nanosecond, from: self) }
    var prevlastday: Int { return self.getLastDayOfPrevMonth().day }
    var firstweekday: Int { return self.getFirstDayOfMonth().weekday }
    var lastday: Int { return self.getLastDayOfMonth().day }
}

/**
 * https://eddiekwon.github.io/swift/2018/11/27/UTCtoKST/
 * https://macinjune.com/all-posts/web-developing/swift/xcode-swift-%EB%82%A0%EC%A7%9C%EC%99%80-%EC%8B%9C%EA%B0%84-%EB%8B%A4%EB%A3%A8%EA%B8%B0-date-datecomponents/
 */
extension Date {
    
    static func getDateFormatter(_ format: String = "yyyyMMdd") -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current//Locale(identifier: "en_US")
        //formatter.timeZone = TimeZone(abbreviation: "UTC")!
        formatter.dateFormat = format//"yyyyMMdd"//"yyyyMMddhhmm" // yyyy-MM-dd hh:mm:ss
        return formatter
    }
    
    static func getCalendar() -> Calendar {
        var calendar = Calendar.current//Calendar(identifier: .gregorian)
        calendar.locale = Locale.current//Locale(identifier: "en_US")
        //calendar.timeZone = TimeZone(abbreviation: "UTC")!
        return calendar
    }
    
    func set(year: Int? = nil, month: Int? = nil, day: Int? = nil) -> Date {
        let calendar = Date.getCalendar()
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        if let year = year { components.year = year }
        if let month = month { components.month = month }
        if let day = day { components.day = day }
        return calendar.date(from: components) ?? self
    }
    
    func set(hour: Int? = nil, minute: Int? = nil, second: Int? = nil, nanosecond: Int? = nil) -> Date {
        let calendar = Date.getCalendar()
        var components = calendar.dateComponents([.hour, .minute, .second, .nanosecond], from: self)
        if let hour = hour { components.hour = hour }
        if let minute = minute { components.minute = minute }
        if let second = second { components.second = second }
        if let nanosecond = nanosecond { components.nanosecond = components.nanosecond! + nanosecond }
        return calendar.date(from: components) ?? self
    }
    
    func add(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil, nanosecond: Int? = nil) -> Date {
        // 방법1
        let calendar = Date.getCalendar()
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
        if let year = year { components.year = components.year! + year }
        if let month = month { components.month = components.month! + month }
        if let day = day { components.day = components.day! + day }
        if let hour = hour { components.hour = components.hour! + hour }
        if let minute = minute { components.minute = components.minute! + minute }
        if let second = second { components.second = components.second! + second }
        if let nanosecond = nanosecond { components.nanosecond = components.nanosecond! + nanosecond }
        return calendar.date(from: components) ?? self
        
        /* 방법2
        let components = DateComponents()
        if let year = year { components.year = components.year! + year }
        if let month = month { components.month = components.month! + month }
        if let day = day { components.day = components.day! + day }
        if let hour = hour { components.hour = components.hour! + hour }
        if let minute = minute { components.minute = components.minute! + minute }
        if let second = second { components.second = components.second! + second }
        if let nanosecond = nanosecond { components.nanosecond = components.nanosecond! + nanosecond }
        return Calendar.current.date(byAdding: components, to: self) ?? self
        */
    }
    
    func toDate() -> Date {
        let calendar = Date.getCalendar()
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components) ?? self
    }
}

extension Date {
    
    func firstDayOfMonth() -> Date {
        let calendar = Date.getCalendar()
        return calendar.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!.toDate()
    }
    
    func lastDayOfMonth() -> Date {
        let calendar = Date.getCalendar()
        return calendar.date(byAdding: DateComponents(month: 1, day: -1), to: self.firstDayOfMonth())!.toDate()
    }
}

extension Date {
    
    func getLastYear() -> Date {
        let calendar = Date.getCalendar()
        return calendar.date(byAdding: .year, value: -1, to: self)!.toDate()
    }
    
    func getLast6Month() -> Date {
        let calendar = Date.getCalendar()
        return calendar.date(byAdding: .month, value: -6, to: self)!.toDate()
    }
    
    func getLast3Month() -> Date {
        let calendar = Date.getCalendar()
        return calendar.date(byAdding: .month, value: -3, to: self)!.toDate()
    }
    
    func getLastMonth() -> Date {
        let calendar = Date.getCalendar()
        return calendar.date(byAdding: .month, value: -1, to: self)!.toDate()
    }
    
    func getPrevMonth() -> Date {
        let calendar = Date.getCalendar()
        return calendar.date(byAdding: .month, value: -1, to: self)!.toDate()
    }
    
    func getLast7Day() -> Date {
        let calendar = Date.getCalendar()
        return calendar.date(byAdding: .day, value: -7, to: self)!.toDate()
    }
    
    func getLast30Day() -> Date {
        let calendar = Date.getCalendar()
        return calendar.date(byAdding: .day, value: -30, to: self)!.toDate()
    }
    
    func getYesterday() -> Date {
        let calendar = Date.getCalendar()
        return calendar.date(byAdding: .day, value: -1, to: self)!.toDate()
    }
    
    func getNext3Month() -> Date {
        let calendar = Date.getCalendar()
        return calendar.date(byAdding: .month, value: 3, to: self)!.toDate()
    }
    
    func getNextMonth() -> Date {
        let calendar = Date.getCalendar()
        return calendar.date(byAdding: .month, value: 1, to: self)!.toDate()
    }
    
    func getNext14Day() -> Date {
        let calendar = Date.getCalendar()
        return calendar.date(byAdding: .day, value: 14, to: self)!.toDate()
    }
    
    func getTomorrow() -> Date {
        let calendar = Date.getCalendar()
        return calendar.date(byAdding: .day, value: 1, to: self)!.toDate()
    }
    
    func getFirstDayOfPrevMonth() -> Date {
        let calendar = Date.getCalendar()
        let components: NSDateComponents = calendar.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month -= 1
        return calendar.date(from: components as DateComponents)!.toDate()
    }
    
    func getLastDayOfPrevMonth() -> Date {
        let calendar = Date.getCalendar()
        let components: NSDateComponents = calendar.dateComponents([.year, .month], from: self) as NSDateComponents
        components.day = 1
        components.day -= 1
        return calendar.date(from: components as DateComponents)!.toDate()
    }
    
    func getFirstDayOfMonth() -> Date {
        let calendar = Date.getCalendar()
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)!.toDate()
    }
    
    func getLastDayOfMonth() -> Date {
        let calendar = Date.getCalendar()
        let components: NSDateComponents = calendar.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month += 1
        components.day = 1
        components.day -= 1
        return calendar.date(from: components as DateComponents)!.toDate()
    }
    
    func getFirstDayOfNextMonth() -> Date {
        let calendar = Date.getCalendar()
        let components: NSDateComponents = calendar.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month += 1
        return calendar.date(from: components as DateComponents)!.toDate()
    }
    
    func getLastDayOfNextMonth() -> Date {
        let calendar = Date.getCalendar()
        let components: NSDateComponents = calendar.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month += 2
        components.day = 1
        components.day -= 1
        return calendar.date(from: components as DateComponents)!.toDate()
    }
    
    func isToday() -> Bool {
        let calendar = Date.getCalendar()
        return calendar.isDateInToday(self)
    }
    
    func print() {
        Swift.print("\(self.year)년 \(self.month)월 \(self.day)일")
    }
}

/**
 * 날짜 비교
 * https://stackoverflow.com/questions/39018335/swift-3-comparing-date-objects
 */
extension Date {
    
    func isEqualTo(_ date: Date) -> Bool {
        return self.toDate() == date.toDate()
    }
    
    func isGreaterThan(_ date: Date) -> Bool {
        return self.toDate() > date.toDate()
    }
    
    func isSmallerThan(_ date: Date) -> Bool {
        return self.toDate() < date.toDate()
    }
}

extension Date {
    /**
     * Date to String
     * https://qiita.com/k-yamada-github/items/8b6411959579fd6cd995
     */
    func format(_ format: String = "yyyyMMdd") -> String {
        let formatter = Date.getDateFormatter(format)
        return formatter.string(from: self)
    }
}

extension String {
    /**
     * String to Date
     * https://www.maddysoft.com/articles/dates.html
     * http://monibu1548.github.io/2018/05/13/string-date-convert/
     */
    func toDate(format: String = "yyyy.MM.dd") -> Date? {
        let formatter = Date.getDateFormatter(format)
        return formatter.date(from: self)?.toDate()
    }
}
