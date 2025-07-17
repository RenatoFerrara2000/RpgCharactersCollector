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
                Button{
                    addCharacter()
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
 
    func deleteCharacter(_ offsets: IndexSet) {
        for offset in offsets {
            modelContext.delete(characterArray[offset])
        }
    }
    
    func addCharacter() {
        let newCharacter = Character(name: "New Character", characterDescription: "", role: "")
        modelContext.insert(newCharacter)
        
        if let  trait = viewModel.selectedFilter?.trait  {
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
