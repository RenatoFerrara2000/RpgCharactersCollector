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
    @Query var characters: [CharacterModel]  // Scoped fetch

    
    @Query var traits: [Traits]
    
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
                            .badge(grouped[filter.name]?.count ?? 0)
                        
                    }
                }.onDelete(perform: deleteTraits)
            }
            }
            .toolbar{
                Button {
                    modelContext.insert(Traits(name: "New Trait"))
                    modelContext.insert(Traits(name: "New Trait2"))
                    modelContext.insert(Traits(name: "New Trait3"))
                } label: {
                    Label("Add samples)", systemImage: "key")
                }
        }
    }
    
    func deleteTraits(_ offsets: IndexSet) {
        for offset in offsets {
            let traitName = traitsFilter[offset].name

            // 1. Delete trait references from characters ((this is the only reason we have the query for characters, there is probably a better way withouth having to fetch characters.
            for character in characters {
                if character.traitsList.contains(where: { $0.name == traitName }) {
                    character.traitsList.removeAll(where: { $0.name == traitName })
                }
            }

            // 2. Delete all Trait instances with matching name
            for trait in traits where trait.name == traitName {
                modelContext.delete(trait)
            }
        }

        // 3. Save changes
        do {
            try modelContext.save()
        } catch {
            print("Failed to delete traits: \(error)")
        }
    }
}

/*
#Preview {
    SidebarView(selectedFilter: .constant(nil))
 }
*/
