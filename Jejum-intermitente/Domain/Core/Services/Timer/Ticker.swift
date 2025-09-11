//
//  Ticker.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

public protocol Ticker {
    var isRunning: Bool { get }
    func start(interval: TimeInterval, handler: @escaping () -> Void)
    func stop()
}
