//
//  characterModel.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 28/04/25.
//


import SwiftData
import Foundation

@Model
class CharacterModel {
    //  due to cloudKit: All properties must either have default values or be marked as optional, alongside their initializer.

    var name: String = "Character Name"
    var characterDescription: String = "Character Description"
    var role: String = "Character role"
    private(set) var creationDate = Date.now // can't be a let due to swift 6, SwiftData needs to be able to write to the object when loading it from storage.
    var modificationDate: Date?
    // SwiftData automatically knows and connects traits to  the character
    var traitsList = [Traits]()

    
    init( name: String, characterDescription: String, role: String) {
         self.name = name
        self.characterDescription = characterDescription
        self.role = role
      }
 
}


