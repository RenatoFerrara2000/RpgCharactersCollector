//
//  CharacterView.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 07/05/25.
//
import SwiftUI
import SwiftData

struct CharacterView: View {
    
    @State  var character: Character
    @Environment(\.modelContext) var modelContext
    @Query var allTraits: [Traits]
    
    var labelTraits: String {
        let traits = character.traitsList ?? []
        if traits.isEmpty {
            return NSLocalizedString("No Traits", comment: "")
        } else {
            // Create a Set from trait names to eliminate duplicates
            let uniqueTraits = Set(traits.compactMap { $0.name })
            // Convert back to array and join with commas
            return Array(uniqueTraits).sorted().joined(separator: ", ")
        }
    }
    
    var body: some View {
        Form{
            Section{
                VStack(alignment: .leading) {
                    TextField("Character name", text: $character.name, prompt: Text("Enter the character name"))
                        .font(.title)
                    
                    TextField("Role", text: $character.role, prompt: Text("Enter the character role"))
                    
                    if(character.modificationDate == nil)
                    {
                        Text("**Created:** \(character.creationDate.formatted(date: .long, time: .shortened))")
                            .foregroundStyle(.secondary)
                    } else {
                        Text("**Modified:** \(character.modificationDate!.formatted(date: .long, time: .shortened))")
                            .foregroundStyle(.secondary)
                    }
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
                            !characterTraits.contains { $0.id == trait.id }
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
            
            Section {
                VStack(alignment: .leading) {
                    Text("Description")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    
                    TextField("Description", text: $character.characterDescription, prompt: Text("Enter Character Description"))
                }
            }
            Section{
                CharacterConversation(character: character )
            }
        }
    }
}


#Preview {
    CharacterView(character: .example)
        .environment(ViewModel())
}
