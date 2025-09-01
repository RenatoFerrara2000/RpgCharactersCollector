//
//  AwardsTest.swift
//  CastKeeper
//
//  Created by Renato Ferrara on 28/08/25.
//

import Testing
import SwiftData
@testable import CastKeeper


struct AwardsTest {
    
    private var context: ModelContext
    private var container: ModelContainer
    
    @MainActor
    init() throws {
        // Create an in-memory model container for testing
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        self.container = try ModelContainer(for: Character.self, Traits.self, configurations: config)
        self.context = container.mainContext
    }
    
    let awards = Award.allAwards

    @Test func testAwardIDMatchesName() {
             for award in awards {
                 #expect(award.id == award.name, "Award ID should always match its name.")
            }
        }
    
    @Test func testClosedAwards() {
        // GIVEN
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]
        let viewModel = AwardsView.AwardsViewModel()
         viewModel.modelContext = context
        
        for (count, value) in values.enumerated() {
            for _ in 0..<value {
                let char  =  Character(name: "Test", characterDescription: "Test", role: "Test")
                context.insert(char)
                do {
                    try  context.save()
                } catch {
                    fatalError("couldn't save current context.")
                }
            }
            
            // WHEN
            let matches = awards.filter { award in
                viewModel.isAwardEarned(award)
            }
            
            //THEN
            #expect(matches.count == count + 1,  "Completing \(value) characters should unlock \(count + 1) awards.")
            
            // Clear existing characters
            let existingChars = try! context.fetch(FetchDescriptor<Character>())
            print(existingChars.count)
            for char in existingChars {
                context.delete(char)
            }
         }
    }
}
