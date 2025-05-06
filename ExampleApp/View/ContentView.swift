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
    
    var charactersFiltered: [CharacterModel] {
        let filter = viewModel.selectedFilter ?? viewModel.all
        
        var result = characterArray
        
        // Check if filter has a specific trait
        if let trait = filter.trait {
            result = characterArray.filter { character in
                character.traitsList.contains { $0.name == trait.name}
            }
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
            List {
                ForEach(charactersFiltered) { character in
                    CharacterRow(character: character)
                }
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
    }
    
    
    func deleteAll() {
        do {
            try modelContext.delete(model: CharacterModel.self)
        } catch {
            print("Failed to delete students.")
        }
    }
}

/*
#Preview {
    @Previewable @Environment(ViewModel.self)  var viewModel
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: CharacterModel.self, configurations: config)
    let romeo3 = CharacterModel(name: "Romeo3", characterDescription: "A very strong hero3", role: "hero3")
    
    container.mainContext.insert(romeo3)
     

    
    return ContentView()
        .modelContainer(container)
        .environment(viewModel)

}


*/
