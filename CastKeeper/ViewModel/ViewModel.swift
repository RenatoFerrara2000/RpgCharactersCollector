//
//  ViewModel.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 30/04/25.
//
import SwiftUI
import SwiftData
 
// extension ContentView{
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
        
   var selectedCharacter: Character? {
              didSet {
                  print("Selected character changed to: \(selectedCharacter?.name ?? "None")")
              }
          }
        var sortType = SortType.dateCreated
        
        
        
        
        var sortNewestFirst = true
        var filterEnabled = false
        
        
        
        var smartFilters: [Filter]?
        
        
        init() {
            selectedFilter = all
            smartFilters = [all, recent]
            
        }
        
        // Content View
        
          var searchText = ""
          var currentTokens = [Traits]()
          var suggestions: [Traits] = []
        
        func filterCharacters(characterArray: [Character], ) -> [Character] {
            let filter =  selectedFilter ??  all
            var result = characterArray
            let trimmedSearchText = searchText.trimmingCharacters(in: .whitespaces)

            result = characterArray.filter { character in
                
                // Check if filter has a specific trait
                if let trait = filter.trait {
                        if let traits = character.traitsList {
                            // Then check if any trait in the list matches the name
                            return traits.contains { $0.name == trait.name }
                        } else {
                            // If traitsList is nil, this character doesn't have the trait
                            return false
                        }
                }
                
                if searchText.isEmpty == false {
                    // If we have search text, make sure this item matches.
                    if character.name.localizedCaseInsensitiveContains(trimmedSearchText) == false {
                        return false
                    }
                }
                
                if currentTokens.isEmpty == false {
                    // If we have search tokens, loop through them all to make sure one of them matches our movie.
                    for token in currentTokens {
                        for trait in character.traitsList ?? [] {
                            if token.name.localizedCaseInsensitiveContains(trait.name) {
                                return true
                            }
                        }
                    }
                    return false
                }
                return true
            }
            
            // Check if filter has a specific date
            if filter.minModificationDate != Date.distantPast {
                result = result.filter { character in
                    (character.modificationDate ?? character.creationDate) > filter.minModificationDate
                }
            }
            
            return result.sorted { char1, char2 in
                if filterEnabled {
                    if  sortType == .dateCreated {
                        if  sortNewestFirst {
                            return char1.creationDate > char2.creationDate
                        } else {
                            return char1.creationDate < char2.creationDate
                        }
                    } else {
                        let date1 = char1.modificationDate ?? char1.creationDate
                        let date2 = char2.modificationDate ?? char2.creationDate
                        if  sortNewestFirst {
                            return date1 > date2
                        } else {
                            return date1 < date2
                        }
                    }
                } else {
                    return char1.name < char2.name
                }
            }
        }
    }
    
// }

 
enum SortType: String {
    case dateCreated = "creationDate"
    case dateModified = "modificationDate"
    case name = "name"
}
