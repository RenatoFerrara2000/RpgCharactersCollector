//
//  ViewModel.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 30/04/25.
//
import SwiftUI
import SwiftData
 
@Observable
class ViewModel {
    let all = Filter(id: UUID(),
                     name: NSLocalizedString("All Filters", comment: "Filter name for showing all items"),
                     icon: "tray")
    
    let recent = Filter(id: UUID(),
                        name: NSLocalizedString("Recent Characters", comment: "Filter name for recently modified characters"),
                        icon: "clock",
                        minModificationDate: Date.now.addingTimeInterval((86400 * -7)))
    
    var selectedFilter: Filter?
    var selectedCharacter: Character?
    
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
