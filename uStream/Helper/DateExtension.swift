//
//  DateExtension.swift
//  uStream
//
//  Created by stanley phillips on 3/4/21.
//

import Foundation

extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else {
            preconditionFailure("Take a look to your format")
        }
        return date
    }
}

extension Date {
    //    Wednesday, Sep 12, 2018           --> EEEE, MMM d, yyyy
    //    09/12/2018                        --> MM/dd/yyyy
    //    09-12-2018 14:11                  --> MM-dd-yyyy HH:mm
    //    Sep 12, 2:11 PM                   --> MMM d, h:mm a
    //    September 2018                    --> MMMM yyyy
    //    Sep 12, 2018                      --> MMM d, yyyy
    //    Wed, 12 Sep 2018 14:11:54 +0000   --> E, d MMM yyyy HH:mm:ss Z
    //    2018-09-12T14:11:54+0000          --> yyyy-MM-dd'T'HH:mm:ssZ
    //    12.09.18                          --> dd.MM.yy
    //    10:41:02.112                      --> HH:mm:ss.SSS
    
    enum DateFormatType: String {
        case full = "EEEE, MMM d, yyyy"
        case fullNumeric = "MM/dd/yyyy"
        case fullNumericTimestamp = "MM-dd-yyyy HH:mm"
        case monthDayTimestamp = "MMM d, h:mm a"
        case monthYear = "MMMM yyyy"
        case monthDayYear = "MMM d, yyyy"
        case fullWithTimezone = "E, d MMM yyyy HH:mm:ss Z"
        case fullNumericWithTimezone = "yyyy-MM-dd'T'HH:mm:ssZ"
        case short = "dd.MM.yy"
        case timestamp = "HH:mm:ss.SSS"
    }
    
    func dateToString(format: DateFormatType) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
}
