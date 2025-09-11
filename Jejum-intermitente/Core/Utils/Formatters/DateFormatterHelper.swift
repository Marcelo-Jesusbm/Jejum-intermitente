//
//  DateFormatterHelper.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

enum DateFormatterHelper {
    static func timeShort(from date: Date, use24h: Bool) -> String {
        let df = DateFormatter()
        df.locale = .current
        if use24h {
            df.setLocalizedDateFormatFromTemplate("HHmm")
        } else {
            df.timeStyle = .short
            df.dateStyle = .none
        }
        return df.string(from: date)
    }

    static func dateTimeShort(from date: Date, use24h: Bool) -> String {
        let df = DateFormatter()
        df.locale = .current
        if use24h {
            df.setLocalizedDateFormatFromTemplate("yMMMd HHmm")
        } else {
            df.dateStyle = .short
            df.timeStyle = .short
        }
        return df.string(from: date)
    }
}
