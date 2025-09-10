//
//  DateFormatterHelper.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

enum DateFormatterHelper {
    static func timeShort(from date: Date) -> String {
        let df = DateFormatter()
        df.locale = .current
        df.timeStyle = .short
        df.dateStyle = .none
        return df.string(from: date)
    }

    static func dateTimeShort(from date: Date) -> String {
        let df = DateFormatter()
        df.locale = .current
        df.timeStyle = .short
        df.dateStyle = .short
        return df.string(from: date)
    }
}
