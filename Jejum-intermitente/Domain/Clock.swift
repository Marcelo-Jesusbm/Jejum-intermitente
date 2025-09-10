//
//  Clock.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

public protocol Clock {
    func now() -> Date
}

public struct SystemClock: Clock {
    public init() {}
    public func now() -> Date { Date() }
}
