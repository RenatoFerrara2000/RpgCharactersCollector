//
//  Filter.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 30/04/25.
//

import Foundation

struct Filter: Identifiable, Hashable {
    var id: UUID
    var name: String
    var icon: String
    var miniModificationDate = Date.distantPast
    var tag: Traits?
    
    
    func hash(into hasher: inout Hasher){
        hasher.combine(id)
    }
    
    static func ==(lhs: Filter, rhs: Filter) -> Bool {
        lhs.id == rhs.id
    }
}
