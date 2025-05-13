//
//  ViewModel.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 30/04/25.
//
import SwiftUI

@Observable
class ViewModel {
    let all = Filter(id: UUID(), name: "All Filters", icon: "tray")
    let recent = Filter(id: UUID(), name: "Recent characters", icon: "clock", minModificationDate: Date.now.addingTimeInterval((86400 * -7)))
    
    var selectedFilter: Filter?
    var selectedCharacter: CharacterModel?
    
     var sortType = SortType.dateCreated

   
 
 
     var sortNewestFirst = true
     var filterEnabled = false



    var smartFilters: [Filter]?
    
    
    init() {
        selectedFilter = all
         smartFilters = [all, recent]
         
    }
    
    
}

 
enum SortType: String {
    case dateCreated = "creationDate"
    case dateModified = "modificationDate"
    case name = "name"
}
