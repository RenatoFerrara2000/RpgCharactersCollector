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
            XCTAssertTrue(app.navigationBars.buttons["Filter-Button"].exists, "There should be a Filters button on launch.")
             XCTAssertTrue(app.navigationBars.buttons["Add-Character-Button"].exists, "There should be a New Character button on launch.")
        }
    
    func testCreatingAndDeletingCharacters() {
        for tapCount in 1...5 {
            app.buttons["Add-Character-Button"].tap()
            app.buttons["BackButton"].tap()
         
            XCTAssertEqual(app.cells.count, tapCount, "There should be \(tapCount) rows in the list.")
        }
        
        for tapCount in (0...4).reversed() {
            app.cells.firstMatch.swipeLeft()
            if app.buttons["Delete"].exists {
                   app.buttons["Delete"].tap()
               } else if app.buttons["Elimina"].exists {
                   app.buttons["Elimina"].tap()
               } else {
                   XCTFail("Delete button not found in any language")
               }

            XCTAssertEqual(app.cells.count, tapCount, "There should be \(tapCount) rows in the list.")
        }
    }
    
    func testEditingCharacterNameUpdatesCorrectly() {
        XCTAssertEqual(app.cells.count, 0, "There should be no list rows initially.")

        app.buttons["Add-Character-Button"].tap()

                app.textFields["New Character"].tap()
             app.textFields["New Character"].clear()
             app.typeText("Test Passed")
             app.buttons["BackButton"].tap()
             XCTAssertTrue(app.buttons["Test Passed"].exists, "A character named Test Passed should exist.")
     }
    
    func testAllAwardsShowLockedAlert() {
        app.buttons["BackButton"].tap()
        app.buttons["Show Awards Button"].tap()

        for award in app.scrollViews.buttons.allElementsBoundByIndex {
            // so that it works on all kind of devices
            if app.windows.element.frame.contains(award.frame) == false {
                app.swipeUp()
            }
            award.tap()
            let alertExists = app.alerts["Locked"].exists || app.alerts["Bloccato"].exists
            XCTAssertTrue(alertExists, "There should be a Locked alert showing for awards.")
            app.buttons["OK"].tap()
        }
    }
    
}



// To delete all text in a text Field
extension XCUIElement {
    func clear() {
        guard let stringValue = self.value as? String else {
            XCTFail("Failed to clear text in XCUIElement.")
            return
        }

        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        typeText(deleteString)
    }
}
