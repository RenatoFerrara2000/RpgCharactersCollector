//
//  tagsModel.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 28/04/25.
//

import SwiftData
import Foundation

@Model
class Traits {
    var id = UUID()
    var name: String = "Trait name"
    var characterRelated: CharacterModel?
    
    init( name: String, owner: CharacterModel? = nil) {
         self.name = name
    }
}
