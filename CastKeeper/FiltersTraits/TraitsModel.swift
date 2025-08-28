//
//  tagsModel.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 28/04/25.
//

import SwiftData
import Foundation

// swiftlint:disable all
/**
##** Overview**
 This model is used to represent character traits
 Has an inverse relationship with Character Trait list so that when a trait is deleted, so is deleted the reference on the character trait list.
 ##** Parameters**
 - `id`: unique identifier for the trait
 - `name`: name of the trait
 - `characterRelated`: character associated with the trait
 
 */
 // swiftlint:enable all

@Model
class Traits: Comparable {
    // Func for Comparable
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
}
