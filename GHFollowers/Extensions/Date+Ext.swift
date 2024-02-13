//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Marcel Mravec on 23.01.2024.
//

import Foundation

extension Date {

    func convertToMonthYearFormat() -> String {
        formatted(.dateTime.month(.wide).year())
    }
}
