//
//  ExportImportJSONUseCasesTests.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 11/09/25.
//

import XCTest
@testable import Jejum_intermitente

final class ExportImportJSONUseCasesTests: XCTestCase {

    func testExportThenImportIntoAnotherContainer() throws {
        // SOURCE container with sessions and different default plan
        let source = TestContainerBuilder.make()
        try source.setDefaultPlan.execute(id: BuiltinPlans.eighteenSix.id)

        // Create finished and active sessions
        let end = Date()
        let finished = FastingSession(
            planId: BuiltinPlans.sixteenEight.id,
            planName: BuiltinPlans.sixteenEight.name,
            planEmoji: BuiltinPlans.sixteenEight.emoji,
            goalDuration: 16 * 3600,
            startDate: end.addingTimeInterval(-16*3600),
            endDate: end
        )
        try source.sessionRepo.update(finished)

        _ = try source.startFast.execute(.init()) // active in source

        let exported = try source.exportHistoryJSON.execute()
        XCTAssertFalse(exported.isEmpty)

        // DEST container already has an active session => importer should skip active from file
        let dest = TestContainerBuilder.make()
        _ = try dest.startFast.execute(.init()) // active in destination

        let result = try dest.importHistoryJSON.execute(data: exported)
        // Expect at least the finished to be imported or updated, and active skipped due to conflict
        XCTAssertGreaterThanOrEqual(result.imported + result.updated, 1)
        XCTAssertGreaterThanOrEqual(result.skipped, 1)

        // Default plan restored from source file
        XCTAssertEqual(dest.getDefaultPlan.execute().id, BuiltinPlans.eighteenSix.id)
    }
}
