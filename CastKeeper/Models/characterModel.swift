//
//  characterModel.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 28/04/25.
//


import SwiftData
import Foundation

@Model
class Character: Comparable {
    //  due to cloudKit: All properties must either have default values or be marked as optional, alongside their initializer.

    var name: String = "Character Name"
    var characterDescription: String = "Character Description"
    var role: String = "Character role"
    
    // can't be a let due to swift 6, SwiftData needs to be able to write to the object when loading it from storage.
    private(set) var creationDate = Date.now
    
    // SwiftData automatically knows and connects traits to  the character. MUST be optional because of relationship
    var modificationDate: Date?
 
    //  When this character is deleted, remove its trait owner
    @Relationship(deleteRule: .nullify, inverse: \Traits.characterRelated)
    var traitsList: [Traits]?

    // Func for Comparable
    static func < (lhs: Character, rhs: Character) -> Bool {
        let left = lhs.name.localizedLowercase
        let right = rhs.name.localizedLowercase
        
        if left == right {
            return lhs.name < rhs.name
        } else {
            return left < right
        }

    }
    
    init( name: String, characterDescription: String, role: String) {
         self.name = name
        self.characterDescription = characterDescription
        self.role = role
      }
 
    static var example: Character {
        return Character(name: "Example Character", characterDescription: "Example of a descrpition", role: "Example Role")
    }
}


