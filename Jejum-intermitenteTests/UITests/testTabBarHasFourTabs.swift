//
//  testTabBarHasFourTabs.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 12/09/25.
//

import XCTest

final class SmokeUITests: XCTestCase {

    func testTabBarHasFourTabs() {
        let app = XCUIApplication()
        app.launch()

        // Verifica que há pelo menos 4 botões na Tab Bar
        let buttons = app.tabBars.buttons
        XCTAssertGreaterThanOrEqual(buttons.count, 4, "Tab bar should have at least 4 tabs")

        // Tenta tocar nas abas por título em pt/en
        let titles = ["Hoje", "Today", "Histórico", "History", "Planos", "Plans", "Ajustes", "Settings"]
        for t in titles {
            if buttons[t].exists {
                buttons[t].tap()
            }
        }
    }
}
