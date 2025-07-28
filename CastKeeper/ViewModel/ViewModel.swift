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
    let all = Filter(
        id: UUID(),
        name: NSLocalizedString("All Filters", comment: "Filter name for showing all items"),
        icon: "tray")
    
    let recent = Filter(
        id: UUID(),
        name: NSLocalizedString("Recent Characters", comment: "Filter name for recently modified characters"),
        icon: "clock",
        minModificationDate: Date.now.addingTimeInterval((86400 * -7)))
    
    var selectedFilter: Filter?
    
    var smartFilters: [Filter]?
    init() {
        selectedFilter = all
        smartFilters = [all, recent]
    }
    
    var selectedCharacter: Character?
     
    // Content View
    var sortType = SortType.dateCreated
    var sortNewestFirst = true
    var filterEnabled = false
    
    var searchText = ""
    var currentTokens = [Traits]()
    var suggestions: [Traits] = []
    
    func filterCharacters(characterArray: [Character] ) -> [Character] {
        var result = characterArray
        
        result = applyTraitFilter(to: result)
        result = applySearchTextFilter(to: result)
        result = applyTokenFilter(to: result)
        result = applyDateFilter(to: result)
        return applySorting(to: result)
    }
    
    func applyTraitFilter(to characterArray: [Character]) -> [Character] {
        let filter = selectedFilter ?? all
        return characterArray.filter { character in
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
            // If filter has no specific trait, include all characters
            return true
        }
    }
    
    func applySearchTextFilter(to characters: [Character]) -> [Character] {
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespaces)
        guard !trimmedSearchText.isEmpty else { return characters }
        
        return characters.filter { character in
            character.name.localizedCaseInsensitiveContains(trimmedSearchText)
        }
    }
    
    func applyTokenFilter(to characters: [Character]) -> [Character] {
        guard !currentTokens.isEmpty else { return characters }
        
        return characters.filter { character in
            for token in currentTokens {
                for trait in character.traitsList ?? [] where token.name.localizedCaseInsensitiveContains(trait.name) {
                    return true
                }
            }
            return false
        }
    }
    
    private func applyDateFilter(to characters: [Character]) -> [Character] {
        let filter =  selectedFilter ??  all
        
        guard filter.minModificationDate != Date.distantPast else { return characters }
        
        return characters.filter { character in
            let dateToCheck = character.modificationDate ?? character.creationDate
            return dateToCheck > filter.minModificationDate
        }
    }
    
    func applySorting (to characters: [Character]) -> [Character] {
        return characters.sorted { char1, char2 in
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
