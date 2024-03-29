//
//  String+Ext.swift
//  GHFollowers
//
//  Created by Marcel Mravec on 23.01.2024.
//

import Foundation

extension String {

    func convertToDate() -> Date? {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current
        return dateFormatter.date(from: self)
    }

    func convertToDisplayFormat() -> String {
        guard let date = self.convertToDate() else { return "N/A"}
        return date.convertToMonthYearFormat()
    }
}
// both funcs are obsolete now, I just keep them for future reference
