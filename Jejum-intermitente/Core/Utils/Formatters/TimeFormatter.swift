//
//  TimeFormatter.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

enum TimeFormatter {
    static func hms(_ seconds: TimeInterval) -> String {
        let s = max(0, Int(seconds.rounded()))
        let h = s / 3600
        let m = (s % 3600) / 60
        let sec = s % 60
        return String(format: "%02d:%02d:%02d", h, m, sec)
    }
}
