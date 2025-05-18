//
//  SidebarView.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 30/04/25.
//

import SwiftUI
import SwiftData

struct SidebarView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(ViewModel.self) private var viewModel
    @Binding var selectedFilter: Filter?
    @Query var characters: [Character]
    @Query var traits: [Traits]
    
    
    @State private var   tagToRename: Traits?
    @State private var   newTagName: String = ""
    @State private var   isRenamingTag: Bool = false
    @State private var showingAwards = false

    
    
    // build a list of Filter out of traits
    var traitsFilter: [Filter] {
        let grouped = Dictionary(grouping: traits, by: { $0.name })
        let sortedGrouped = grouped.sorted { $0.key < $1.key }
        
        return sortedGrouped.map { (name, traits) in
            Filter(id: traits.first!.id, name: name, icon: "tag", trait: traits.first!)
        }
    }
    
    var body: some View {
        List(selection: $selectedFilter) {
            Section("Smart filters") {
                ForEach(viewModel.smartFilters!){ filter in
                    NavigationLink(value: filter) {
                        Label(filter.name, systemImage: filter.icon)
                    }
                }
            }
            
            Section("Traits"){
                let grouped = Dictionary(grouping: traits, by: { $0.name })
                ForEach(traitsFilter){ filter in
                    NavigationLink(value: filter){
                        Label(filter.name, systemImage: filter.icon)
                            .badge(countCharactersWithTrait(traitName: filter.name))
                            .contextMenu {
                                Button {
                                    guard let traitSelected = traits.first(where: { $0.name == filter.name }) else { return }
                                    renameTrait(traitSelected)
                                } label: {
                                    Label("Rename", systemImage: "pencil")
                                }
                            }
                    }
                }.onDelete(perform: deleteTraits)
            }
        }
        .toolbar{
            // will not be in production
#if DEBUG
            Button {
                modelContext.insert(Traits(name: "New Trait"))
                modelContext.insert(Traits(name: "New Trait2"))
                modelContext.insert(Traits(name: "New Trait3"))
            } label: {
                Label("Add samples)", systemImage: "key")
            }
#endif
            Button {
                showingAwards.toggle()
            } label: {
                Label("Show awards", systemImage: "rosette")
            }
            
            Button {
                modelContext.insert(Traits(name: "New Trait"))
            } label: {
                Label("Add samples)", systemImage: "plus")
            }
        }
        .alert("Rename Character", isPresented: $isRenamingTag){
            Button("OK", action: completeRename)
            Button("Cancel", role: .cancel) {}
            TextField("New Name", text: $newTagName)
        }
        .sheet(isPresented: $showingAwards, content: AwardsView.init)

    }
    
    func countCharactersWithTrait(traitName: String) -> Int {
        var count = 0
        
        for character in characters {
            if let traits = character.traitsList {
                if traits.contains(where: { $0.name == traitName }) {
                    count += 1
                }
            }
        }
        return count
    }
    
    func deleteTraits(_ offsets: IndexSet) {
        for offset in offsets {
            let traitName = traitsFilter[offset].name
            
            // 1. Safely delete trait references from characters
            for character in characters {
                // Only attempt to modify traitsList if it exists
                if var traits = character.traitsList {
                    traits.removeAll(where: { $0.name == traitName })
                    character.traitsList = traits
                }
            }
            
            // 2. Delete all Trait instances with matching name
            for trait in traits where trait.name == traitName {
                modelContext.delete(trait)
            }
        }
    }
    
    func renameTrait(_ trait: Traits) {
        tagToRename = trait
        newTagName = trait.name
        isRenamingTag = true
        
    }
    
    func completeRename() {
        guard let oldName = tagToRename?.name else { return }
        
        // 1. Update all Traits with the same name
        for trait in traits where trait.name == oldName {
            trait.name = newTagName
        }
    }
}


#Preview {
    SidebarView(selectedFilter: .constant(nil))
        .environment(ViewModel())
}

