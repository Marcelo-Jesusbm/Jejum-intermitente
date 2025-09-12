//
//  FixedClock.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 11/09/25.
//

import Foundation

@testable import Jejum_intermitente

final class FixedClock: Clock {
    private(set) var current: Date
    init(_ date: Date) { self.current = date }
    func now() -> Date { current }
    func advance(_ interval: TimeInterval) { current = current.addingTimeInterval(interval) }
}
