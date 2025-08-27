//
//  AssetsTest.swift
//  CastKeeperTests
//
//  Created by Renato Ferrara on 27/08/25.
//

import Testing
import UIKit
@testable import CastKeeper


struct AssetsTest {
    
    @Test func testAwardsLoadCorrectly() {
         #expect(Award.allAwards.isEmpty == false, "Failed to load awards from JSON.")
    }

}
