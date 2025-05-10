//
//  ContentView.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 28/04/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query var characterArray: [CharacterModel]
    @Environment(\.modelContext) var modelContext
    @Environment(ViewModel.self) private var viewModel
    @Binding var selectedCharacter: CharacterModel?

    
    var charactersFiltered: [CharacterModel] {
        let filter = viewModel.selectedFilter ?? viewModel.all
        
        var result = characterArray
        
        // Check if filter has a specific trait
        if let trait = filter.trait {
            result = characterArray.filter { character in
                if let traits = character.traitsList {
                    // Then check if any trait in the list matches the name
                    return traits.contains { $0.name == trait.name }
                } else {
                    // If traitsList is nil, this character doesn't have the trait
                    return false
                }            }
        }
        
        // Check if filter has a specific date
        if filter.minModificationDate != Date.distantPast {
            result = result.filter { character in
                (character.modificationDate ?? character.creationDate) > filter.minModificationDate
                
            }
            
        }
        return result.sorted()
    }
    
    var body: some View {
        NavigationStack {
            List(selection: $selectedCharacter) {
                ForEach(charactersFiltered) { character in
                    CharacterRow(character: character)
                }.onDelete(perform: deleteCharacter)
            }
            .toolbar {
                Button("Samples", action: addSamples)
                Button("Del", action: deleteAll)
            }
            .navigationTitle(Text("Chr - \(viewModel.selectedFilter?.name ?? "")"))
        }
    }
    
    func addSamples() {
        let romeo = CharacterModel(name: "Romeo", characterDescription: "A very strong hero", role: "hero")
        let romeo2 = CharacterModel(name: "Romeo2", characterDescription: "A very strong hero2", role: "hero2")
        let romeo3 = CharacterModel(name: "Romeo3", characterDescription: "A very strong hero3", role: "hero3")
        let romeoOld = CharacterModel(name: "RomeoOLD", characterDescription: "A very OLD hero", role: "OLD hero3")
        
        romeoOld.modificationDate = Date.now.addingTimeInterval(-7 * 60 * 60 * 24 * 365 )
        
        modelContext.insert(romeo)
        modelContext.insert(romeo2)
        modelContext.insert(romeo3)
        modelContext.insert(romeoOld)
        
        romeo3.traitsList = [Traits(name: "Eroe Medievale", owner: romeo3)]
        
        romeo2.traitsList = [Traits(name: "Good Hero", owner: romeo2), Traits(name: "Secret Evil Hero", owner: romeo2) ]

    }
    
    func deleteCharacter(_ offsets: IndexSet) {
        for offset in offsets {
            modelContext.delete(characterArray[offset])
        }

    }
    
    func deleteAll() {
        do {
            try modelContext.delete(model: CharacterModel.self)
        } catch {
            print("Failed to delete students.")
        }
    }
}


#Preview {
         let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: CharacterModel.self, Traits.self, configurations: config)
        
        // Create a sample character with traits
        let romeo = CharacterModel(name: "Romeo", characterDescription: "A very strong hero", role: "hero")
        
        // Create some sample traits
        let brave = Traits(name: "Brave")
        let intelligent = Traits(name: "Intelligent")
        let charismatic = Traits(name: "Charismatic")
        
        // Add traits to the character
        romeo.traitsList = [brave, intelligent, charismatic]
        
        // Insert everything into the context
        container.mainContext.insert(romeo)
        container.mainContext.insert(brave)
        container.mainContext.insert(intelligent)
        container.mainContext.insert(charismatic)


        
        // Create a binding for the selected character
        let viewModel = ViewModel()
        
        // Return the ContentView with the appropriate environment
        return ContentView(selectedCharacter: .constant(romeo))
            .modelContainer(container)
            .environment(viewModel)

}
