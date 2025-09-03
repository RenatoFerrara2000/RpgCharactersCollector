//
//  ContentView.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 28/04/25.
//
import SwiftUI
import SwiftData
/**

 # Overview

 SwiftUI view that serves as the main character management interface, featuring a searchable list with filtering, selection, and CRUD operations.

 Primary content view for character management with search and filtering capabilities.

 ```swift
 struct ContentView: View {
     @Query var characterArray: [Character]
     @Environment(\.modelContext) var modelContext
     @Environment(ViewModel.self) private var viewModel
     
     var body: some View {
         // View implementation
     }
 }
 ```

 ## Architecture

 ### Data Management
 - `@Query var characterArray` - SwiftData query for all characters
 - `@Environment(\.modelContext)` - SwiftData persistence context
 - `@Environment(ViewModel.self)` - Shared app state and filtering logic

 ### Computed Properties
 - `charactersFiltered` - Characters filtered through `viewModel.filterCharacters()`

 ## Features

 ### List Interface
 - **Character rows** using ``CharacterRow`` component
 - **Selection binding** to `viewModel.selectedCharacter`
 - **Swipe-to-delete** functionality

 ### Search & Filtering
 - **Searchable interface** with text and token-based filtering
 - **Token suggestions** for advanced filtering
 - **Dynamic prompt** showing current filter state

 ### Toolbar Actions
 - **Add character button** with "square.and.pencil" icon
 - **TraitsMenuView** component for trait management

 ### Navigation
 - **NavigationStack** container
 - **Dynamic title** showing current filter: "Chr - [FilterName]"

 ## Extension Functions

 All Swift Data related
 
 ### deleteCharacter(_ offsets: IndexSet)
 Removes characters at specified indices from SwiftData context.

 ### addCharacter()
 Creates new character with:
 - Default name: "New Character"
 - Empty description and role
 - Optional trait assignment based on current filter
 - Automatic selection of new character

 */
struct ContentView: View {
    @Query var characterArray: [Character]
    @Environment(\.modelContext) var modelContext
    @Environment(ViewModel.self) private var viewModel
    
    var charactersFiltered: [Character] {
        viewModel.filterCharacters(characterArray: characterArray)
    }
    
    var body: some View {
        @Bindable var viewModel = viewModel
        NavigationStack {
            List(selection: $viewModel.selectedCharacter) {
                ForEach(charactersFiltered) { character in
                    CharacterRow(character: character)
                }.onDelete(perform: deleteCharacter)
            }
            .searchable(text: $viewModel.searchText, tokens: $viewModel.currentTokens, suggestedTokens: $viewModel.suggestions, prompt: Text("Type to filter")) { token in
                Text( token.name)
            }
            .toolbar {
                Button {
                    addCharacter()
                } label: {
                    Label("New Character", systemImage: "square.and.pencil")
                  
                 }
                .accessibilityIdentifier("Add-Character-Button")
                TraitsMenuView()

            }
            .navigationTitle(Text("Chr - \(viewModel.selectedFilter?.name ?? "")"))
        }
    }
}

extension ContentView {
    func deleteCharacter(_ offsets: IndexSet) {
        for offset in offsets {
            modelContext.delete(charactersFiltered[offset])
        }
    }
    
    func addCharacter() {
        print("adding character")
        let newCharacter = Character(name: "New Character", characterDescription: "", role: "")
        modelContext.insert(newCharacter)
        
        if let  trait = viewModel.selectedFilter?.trait {
            newCharacter.traitsList = [Traits(name: trait.name, owner: newCharacter)]
        }
        viewModel.selectedCharacter = newCharacter
    }
}

#Preview {
    let preview = Preview(Character.self)
    preview.addSamples(Character.exampleCharacters)
    let viewModel = ViewModel()

    return ContentView()
        .modelContainer(preview.container)
        .environment(viewModel)
}
