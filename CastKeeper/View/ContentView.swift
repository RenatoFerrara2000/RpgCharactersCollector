//
//  ContentView.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 28/04/25.
//
import SwiftUI
import SwiftData

struct ContentView: View {
    @Query var characterArray: [Character]
    @Query var allTraits: [Traits]
    
    @Environment(\.modelContext) var modelContext
    @State private var viewModel = ViewModel()
    @Binding var selectedCharacter: Character?
    
    @State private var searchText = ""
     @State private var currentTokens = [Traits]()
    @State private var suggestions: [Traits] = []
    
    var charactersFiltered: [Character] {
        filterCharacters()
    }
    
    var body: some View {
        @Bindable var viewModel = viewModel
        NavigationStack {
            List(selection: $selectedCharacter) {
                ForEach(charactersFiltered) { character in
                    CharacterRow(character: character)
                }.onDelete(perform: deleteCharacter)
            }
            .searchable(text: $searchText, tokens: $currentTokens, suggestedTokens: $suggestions, prompt: Text("Type to filter")) { token in
                Text( token.name)
            }
            .toolbar {
                Button{
                    let newCharacter = Character(name: "New Character", characterDescription: "", role: "")
                    modelContext.insert(newCharacter)
                    
                    if let  trait = viewModel.selectedFilter?.trait  {
                        newCharacter.traitsList = [Traits(name: trait.name, owner: newCharacter)]
                    }
                    viewModel.selectedCharacter = newCharacter
                    
                } label: {
                    NavigationLink(destination: DetailView()) {
                        Label("New Character", systemImage: "square.and.pencil")
                    }
                }
                Menu {
                    Button(viewModel.filterEnabled ? "Turn Filter Off" : "Turn Filter On") {
                        viewModel.filterEnabled.toggle()
                    }
                    
                    Divider()
                    
                    Menu("Sort By") {
                        
                        Picker("Sort By", selection: $viewModel.sortType) {
                            Text("Date Created").tag(SortType.dateCreated)
                            Text("Date Modified").tag(SortType.dateModified)
                        }
                        
                        Divider()
                        
                        
                        Picker("Sort Order", selection: $viewModel.sortNewestFirst) {
                            Text("Newest to Oldest").tag(true)
                            Text("Oldest to Newest").tag(false)
                        }
                        
                    }
                    
                    
                } label: {
                    Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                    .symbolVariant(viewModel.filterEnabled ? .fill : .none)                }
            }
            .navigationTitle(Text("Chr - \(viewModel.selectedFilter?.name ?? "")"))
            
        }
    }
}

extension ContentView {
    
    private func filterCharacters() -> [Character] {
        let filter = viewModel.selectedFilter ?? viewModel.all
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
            if viewModel.filterEnabled {
                if viewModel.sortType == .dateCreated {
                    if viewModel.sortNewestFirst {
                        return char1.creationDate > char2.creationDate
                    } else {
                        return char1.creationDate < char2.creationDate
                    }
                } else {
                    let date1 = char1.modificationDate ?? char1.creationDate
                    let date2 = char2.modificationDate ?? char2.creationDate
                    if viewModel.sortNewestFirst {
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
    
    func deleteCharacter(_ offsets: IndexSet) {
        for offset in offsets {
            modelContext.delete(characterArray[offset])
        }

    }
    
    func deleteAll() {
        do {
            try modelContext.delete(model: Character.self)
        } catch {
            print("Failed to delete characters.")
        }
    }
}


#Preview {
    let preview = Preview()
    preview.addSamples(Character.exampleCharacters)
    let viewModel = ViewModel()
    
    return  ContentView(selectedCharacter: .constant(Character.exampleCharacters[0]))
        .modelContainer(preview.container)
        .environment(viewModel)

}
