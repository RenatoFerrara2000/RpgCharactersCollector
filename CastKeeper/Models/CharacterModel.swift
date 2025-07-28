//
//  characterModel.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 28/04/25.
//

import SwiftData
import Foundation

// swiftlint:disable all
/**
## Overview
 This model is used  to rappresent  Characters  that the user can create.
 
 ## Parameters
  - `name`: Name of the Character
 - `description`:  description of the Character
 - `role`:  role assigned to the character
 - `creationDate`:  When the user was created
 - `modificationDate`:  Last time the Character wad modified
 - `traitsList`:  A list of traits the character  
 
 - `allAwards`: Array of all the awards
 - `example`:  single example of an award


 */
 // swiftlint:enable all
@Model
class Character: Comparable {
    //  due to cloudKit: All properties must either have default values or be marked as optional, alongside their initializer.

    var name: String = "Character Name"
    var characterDescription: String = "Character Description"
    var role: String = "Character role"
    
    // can't be a let due to swift 6, SwiftData needs to be able to write to the object when loading it from storage.
    private(set) var creationDate = Date.now
    
    var modificationDate: Date?
 
    //  When this character is deleted, remove its trait owner
    // SwiftData automatically knows and connects traits to  the character. MUST be optional because of relationship
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
    
    init( name: String, characterDescription: String, role: String, characterTraits: [Traits]? = nil) {
        self.name = name
        self.characterDescription = characterDescription
        self.role = role
        self.traitsList = characterTraits
    }
}
