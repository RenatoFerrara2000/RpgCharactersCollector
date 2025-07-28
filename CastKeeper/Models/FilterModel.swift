//
//  Filter.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 30/04/25.
//

import Foundation

// swiftlint:disable all
/**
## Overview
 This model is used  filter the characters
 
 ## Parameters
  - `id`: id of the filter
 - `name`:  name of the filter
 - `icon`:  icon of the filter
 - `minModificationDate`:   minimum modification date for the filter
 - `trait`:  Trait to filter by
 
 */
 // swiftlint:enable all
struct Filter: Identifiable, Hashable {
    var id: UUID
    var name: String
    var icon: String
    var minModificationDate = Date.distantPast
    var trait: Traits?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Filter, rhs: Filter) -> Bool {
        lhs.id == rhs.id
    }
}
