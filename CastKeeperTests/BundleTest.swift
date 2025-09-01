//
//  BundleTest.swift
//  CastKeeper
//
//  Created by Renato Ferrara on 01/09/25.
//

import Testing
import SwiftData
import Foundation
@testable import CastKeeper


class BundleTest {
    
  @Test  func testBundleDecodingAwards() {
        let awards = Bundle.main.decode("Awards.json", as: [Award].self)
      #expect(awards.isEmpty == false, "Awards.json should decode to a non-empty array.")
    }
    
    @Test func testDecodingString() {
         let bundle = Bundle(for: BundleTest.self)
        let data = bundle.decode("DecodableString.json", as: String.self)
        #expect(data == "Sunrise, Parabellum", "The string must match DecodableString.json.")
    }

    @Test func testDecodingDictionary() {
         let bundle = Bundle(for: BundleTest.self)
        let data = bundle.decode("DecodableDictionary.json", as: Dictionary<String, Int>.self)
        #expect(data.count == 3, "There should be three coded items")
        #expect(data["One"] == 1, "Key must match the value as in DecodableDictionary")
    }
}
