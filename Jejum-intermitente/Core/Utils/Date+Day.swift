//
//  Date+Day.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 11/09/25.
//

import Foundation

extension Date {
    func startOfDay (using calendar: Calendar = .current) -> Date {
        calendar.startOfDay(for: self)
    }
}
