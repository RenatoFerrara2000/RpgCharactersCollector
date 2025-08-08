//
//  TraitMenu.swift
//  CastKeeper
//
//  Created by Renato Ferrara on 11/07/25.
//
import SwiftUI
/**
 # Overview

 SwiftUI view that provides a dropdown menu interface for managing character traits, allowing users to add or remove traits from a character.

 ### Menu Structure
 - **Label:** Shows current traits or "No Traits" (localized)
 - **Current traits section:** Checkmarked items with removal functionality
 - **Divider** (if unselected traits exist)
 - **"Add Traits" section:** Available traits to add

 ### Computed Properties

 #### `labelTraits: String`
 Returns formatted string for menu label:
 - Empty state: Localized "No Traits" message
 - With traits: Alphabetically sorted, comma-separated trait names

 ## Functionality

 ### Trait Removal
 - **Current traits** displayed with checkmark icons
 - **Tap to remove** from character's trait list
 - **Array initialization** handles nil traitsList

 ### Trait Addition
 - **Filtered display** shows only unselected traits
 - **Tap to add** appends trait to character
 - **Section grouping** under "Add Traits" header

 ### Data Management
 - **Nil safety:** Initializes `character.traitsList` if needed
 - **Duplicate prevention:** Filters by trait name comparison
 - **Direct manipulation** of character's trait array

 ## UI Elements
 - **Menu label:** Single line, leading alignment
 - **Trait filtering:** Excludes already assigned traits
 - **Conditional sections:** Only shows "Add Traits" if available
 
 */
struct CharacterTraitList: View {
    var character: Character
    var allTraits: [Traits]
    
    var labelTraits: String {
        let traits = character.traitsList ?? []
        if traits.isEmpty {
            return NSLocalizedString("No Traits", comment: "")
        } else {
            return traits.map { $0.name }.sorted().joined(separator: ", ")
        }
    }
    
    var body: some View {
        Menu {
            // Trait character already has
            if let traits = character.traitsList {
                ForEach(traits) { trait in
                    Button {
                        // Create new array if nil
                        if character.traitsList == nil {
                            character.traitsList = []
                        }
                        character.traitsList?.removeAll { $0.id == trait.id }
                    } label: {
                        Label(trait.name, systemImage: "checkmark")
                    }
                }
            }
            
            // Traits the character doesn't have yet
            let characterTraits = character.traitsList ?? []
            let unselectedTraits = allTraits.filter { trait in
                !characterTraits.contains { $0.name == trait.name }
            }
            
            if !unselectedTraits.isEmpty {
                Divider()
                Section("Add Traits") {
                    ForEach(unselectedTraits) { availableTrait in
                        Button {
                            // Initialize the array if it's nil
                            if character.traitsList == nil {
                                character.traitsList = []
                            }
                            character.traitsList?.append(availableTrait)
                        } label: {
                            Text(availableTrait.name)
                        }
                    }
                }
            }
        } label: {
            Text(labelTraits)
                .multilineTextAlignment(.leading)
                .lineLimit(1)
        }
    }
}

#Preview {
    CharacterTraitList(character: .exampleCharacters[0], allTraits: Traits.exampleTraits)
}
