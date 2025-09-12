//
//  StartStopFastUseCasesTests.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 11/09/25.
//

import XCTest
@testable import Jejum_intermitente

final class StartStopFastUseCasesTests: XCTestCase {

    func testStartFastCreatesActiveSession() throws {
        let fixed = FixedClock(Date())
        let container = TestContainerBuilder.make(clock: fixed)

        XCTAssertNil(try container.sessionRepo.fetchActive())

        let session = try container.startFast.execute(.init())
        XCTAssertNotNil(session.id)
        XCTAssertEqual(try container.sessionRepo.fetchActive()?.id, session.id)
    }

    func testStartingSecondFastThrows() throws {
        let container = TestContainerBuilder.make()

        _ = try container.startFast.execute(.init())
        XCTAssertThrowsError(try container.startFast.execute(.init())) { error in
            XCTAssertEqual(error as? DomainError, .activeSessionExists)
        }
    }

    func testStopFastEndsActiveSession() throws {
        let container = TestContainerBuilder.make()

        _ = try container.startFast.execute(.init())
        let stopped = try container.stopFast.execute()
        XCTAssertNotNil(stopped.endDate)
        XCTAssertNil(try container.sessionRepo.fetchActive())
    }

    func testStopFastWithoutActiveThrows() {
        let container = TestContainerBuilder.make()
        XCTAssertThrowsError(try container.stopFast.execute()) { error in
            XCTAssertEqual(error as? DomainError, .noActiveSession)
        }
    }
}
