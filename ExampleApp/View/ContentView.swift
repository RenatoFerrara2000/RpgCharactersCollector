//
//  ContentView.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 28/04/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query var characterModel: [CharacterModel]
    @Environment(\.modelContext) var modelContext
    @Environment(ViewModel.self) private var viewModel

    var body: some View {
        NavigationStack {
            List {
                ForEach(characterModel) { character in
                    VStack(alignment: .leading) {
                        Text(character.name)
                            .font(.headline)
                        
                        Text(character.creationDate.formatted(date: .long, time: .shortened))
                        
                        ForEach(character.traitsList){ trait in
                            Text(trait.name)
                         }
                    }
                    
                }
            }
            .toolbar {
                Button("Add Samples", action: addSamples)
            }
            .navigationTitle("Characters")
        }
    }
    
    func addSamples() {
        let romeo = CharacterModel(name: "Romeo", characterDescription: "A very strong hero", role: "hero")
        let romeo2 = CharacterModel(name: "Romeo2", characterDescription: "A very strong hero2", role: "hero2")
        let romeo3 = CharacterModel(name: "Romeo3", characterDescription: "A very strong hero3", role: "hero3")
        
        modelContext.insert(romeo)
        modelContext.insert(romeo2)
        modelContext.insert(romeo3)
        
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

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: CharacterModel.self, configurations: config)
    let romeo3 = CharacterModel(name: "Romeo3", characterDescription: "A very strong hero3", role: "hero3")
    
    container.mainContext.insert(romeo3)
    
    return ContentView()
        .modelContainer(container)
}
