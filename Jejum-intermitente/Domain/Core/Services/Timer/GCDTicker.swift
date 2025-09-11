//
//  GCDTicker.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

public final class GCDTicker: Ticker {
    private let queue: DispatchQueue
    private var timer: DispatchSourceTimer?
    private(set) public var isRunning: Bool = false

    public init(queue: DispatchQueue = .main) {
        self.queue = queue
    }

    public func start(interval: TimeInterval, handler: @escaping () -> Void) {
        stop()
        let timer = DispatchSource.makeTimerSource(queue: queue)
        let leeway = DispatchTimeInterval.milliseconds(150)
        timer.schedule(deadline: .now() + interval, repeating: interval, leeway: leeway)
        timer.setEventHandler(handler: handler)
        timer.resume()
        self.timer = timer
        self.isRunning = true
        // Emite um "tick" imediato para sincronizar estado na criação:
        handler()
    }

    public func stop() {
        guard let t = timer else { return }
        t.setEventHandler(handler: nil)
        t.cancel()
        timer = nil
        isRunning = false
    }

    deinit {
        stop()
    }
}
