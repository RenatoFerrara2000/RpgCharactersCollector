//
//  tagsModel.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 28/04/25.
//

import SwiftData
import Foundation

@Model
class Traits: Comparable {
    static func < (lhs: Traits, rhs: Traits) -> Bool {
        let left = lhs.name.localizedLowercase
        let right = rhs.name.localizedLowercase
        
        if left == right {
            return lhs.id.uuidString < rhs.id.uuidString
        } else {
            return left < right
        }

    }
    
     // When a trait is deleted, just remove its reference from the character's trait list 
    @Relationship(deleteRule: .nullify, inverse: \Character.traitsList)

  
    var id = UUID()
    var name: String = "Trait name"
    var characterRelated: Character?
    
    init( name: String, owner: Character? = nil) {
         self.name = name
    }
    
    static var example: Traits {
        return Traits(name: "Example Trait")
    }
}
