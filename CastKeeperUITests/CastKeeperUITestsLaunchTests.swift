//
//  CastKeeperUITestsLaunchTests.swift
//  CastKeeperUITests
//
//  Created by Renato Ferrara on 02/09/25.
//

import XCTest

final class CastKeeperUITestsLaunchTests: XCTestCase {

    var app: XCUIApplication!

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments += ProcessInfo().arguments
        app.launch()
    }
    
      func testAppStartsWithNavigationBar() throws {
        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app
        XCTAssertTrue(app.navigationBars.element.exists, "There should be a navigation bar when the app launches.")

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
             func testAppHasBasicButtonsOnLaunch() throws {
            XCTAssertTrue(app.navigationBars.buttons["Filters"].exists, "There should be a Filters button on launch.")
            XCTAssertTrue(app.navigationBars.buttons["Filter"].exists, "There should be a Filter button on launch.")
            XCTAssertTrue(app.navigationBars.buttons["New Character"].exists, "There should be a New Character button on launch.")
        }
    
    
    func testAddNotesToCharacter() throws {
        // Navigate to character creation
        app.buttons["New Character"].tap()
    }
    }
