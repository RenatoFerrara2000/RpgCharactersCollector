//
//  CharacterTest.swift
//  CastKeeper
//
//  Created by Renato Ferrara on 28/08/25.
//

import Testing
import SwiftData
@testable import CastKeeper


struct CharacterTest {
    
    private var context: ModelContext
     private var container: ModelContainer
    
     @MainActor
     init() throws {
         // Create an in-memory model container for testing
         let config = ModelConfiguration(isStoredInMemoryOnly: true)
         self.container = try ModelContainer(for: Character.self, Traits.self, configurations: config)
         self.context = container.mainContext
     }
    
    @Test("Creating 2 characters and 4 traits") func characterCreationsAndTraits() {
        let hero = Character(name: "HeroTest", characterDescription: "A normal Hero.", role: "Hero of the Test" )
        let villain = Character(name: "VillainTest", characterDescription: "A normal Villain.", role: "Villain of the Test" )
        
        hero.traitsList = [Traits(name: "Good Guy"), Traits(name:"Heroic")]
        
        villain.traitsList = [Traits(name: "Bad Guy"), Traits(name:"Evil")]
        
        context.insert(hero)
        context.insert(villain)
        do {
            try context.save()
            
            let fetchDescriptor = FetchDescriptor<Character>()
            let savedCharacters = try context.fetch(fetchDescriptor)
            #expect(savedCharacters.count == 2)
            
           let traitsFetchDescriptor = FetchDescriptor<Traits>()
            let savedTraits = try context.fetch(traitsFetchDescriptor)
            #expect(savedTraits.count == 4)
        } catch {
             fatalError("Error")
        }

        
     }
    
    @Test("Effect of deleting a trait ") func testDeletingATraitsFromCharacter() throws {
        
        let hero = Character(name: "HeroTest", characterDescription: "A normal Hero.", role: "Hero of the Test" )
        let villain = Character(name: "VillainTest", characterDescription: "A normal Villain.", role: "Villain of the Test" )
        
        hero.traitsList = [Traits(name: "Good Guy"), Traits(name:"Heroic")]
        
        villain.traitsList = [Traits(name: "Bad Guy"), Traits(name:"Evil")]
        
        
        context.insert(hero)
        context.insert(villain)
        
        do {
            context.delete(hero.traitsList![0])
            try context.save()

            let fetchDescriptor = FetchDescriptor<Character>()
            let savedCharacters = try context.fetch(fetchDescriptor)
            #expect(savedCharacters.count == 2)
            #expect(hero.traitsList?.count == 1)
            
            let traitsFetchDescriptor = FetchDescriptor<Traits>()
            let savedTraits = try context.fetch(traitsFetchDescriptor)
            #expect(savedTraits.count == 3)
            
            
        } catch {
            fatalError("Error")
        }
    }
    
    @Test("Effect of deleting a Character ") func testDeletingCharacter() throws {
        
        let hero = Character(name: "HeroTest", characterDescription: "A normal Hero.", role: "Hero of the Test" )
        let villain = Character(name: "VillainTest", characterDescription: "A normal Villain.", role: "Villain of the Test" )
        
        hero.traitsList = [Traits(name: "Good Guy"), Traits(name:"Heroic")]
        
        villain.traitsList = [Traits(name: "Bad Guy"), Traits(name:"Evil")]
        
        
        context.insert(hero)
        context.insert(villain)
        
        do {
             context.delete(hero)
            try context.save()

            let fetchDescriptor = FetchDescriptor<Character>()
            let savedCharacters = try context.fetch(fetchDescriptor)
            #expect(savedCharacters.count == 1)
            #expect(savedCharacters[0].name == "VillainTest")
            
            let traitsFetchDescriptor = FetchDescriptor<Traits>()
            let savedTraits = try context.fetch(traitsFetchDescriptor)
 
            #expect(savedTraits.count == 4)  
            let orphanedTraits = savedTraits.filter { $0.characterRelated == nil }
            #expect(orphanedTraits.count == 2)  // Hero's traits orphaned


            
        } catch {
            fatalError("Error")
        }
    }
}
