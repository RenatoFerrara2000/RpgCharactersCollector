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
    
  
    var id = UUID()
    var name: String = "Trait name"
    var characterRelated: CharacterModel?
    
    init( name: String, owner: CharacterModel? = nil) {
         self.name = name
    }
    
    static var example: Traits {
        return Traits(name: "Example Trait")
    }
}
