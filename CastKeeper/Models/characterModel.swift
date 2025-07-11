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
    
    
     func buildCharacterInstructions() -> String {
        var instructions = """
            You are roleplaying as a character named "\(self.name.isEmpty ? "Unknown Character" : self.name)".
            
            Character Details:
            - Name: \(self.name.isEmpty ? "Unknown" : self.name)
            - Role: \(self.role.isEmpty ? "No specific role" : self.role)
            - Description: \(self.characterDescription.isEmpty ? "No description provided" : self.characterDescription)
            """
        
        // Add traits if they exist
         if let traits = self.traitsList, !traits.isEmpty {
            let traitNames = traits.compactMap { $0.name }.joined(separator: ", ")
            instructions += "\n- Key Traits: \(traitNames)"
        }
        
        instructions += """
            
            
            IMPORTANT GUIDELINES:
            - Stay in character at all times
            - Respond as this character would, based on their description, role, and traits
            - Keep responses conversational and engaging
            - You may be addressing minors, so never use or tolerate offensive language
            - If asked about your identity, you are this character, not an AI
            - Draw from the character's background to inform your responses
            """
        
        return instructions
    }
}


