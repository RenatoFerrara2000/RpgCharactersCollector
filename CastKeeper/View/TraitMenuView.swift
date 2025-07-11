//
//  TraitMenu.swift
//  CastKeeper
//
//  Created by Renato Ferrara on 11/07/25.
//
import SwiftUI

struct TraitMenuView: View {
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
    
    var body:   some View {
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
    TraitMenuView(character: .example, allTraits: [Traits.example])
}
