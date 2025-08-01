//
//  SidebarView.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 30/04/25.
//

import SwiftUI
import SwiftData
/**

 ## Overview

 SwiftUI sidebar view that provides navigation filters and trait management functionality, featuring smart filters, trait-based filtering, and comprehensive trait operations.

 ## SidebarView

 Primary navigation sidebar with filtering and trait management capabilities.

 ## Architecture

 ### Data Management
 - `@Query var characters` - All characters from SwiftData
 - `@Query var traits` - All traits from SwiftData
 - `@Environment(\.modelContext)` - SwiftData persistence context
 - `@Environment(ViewModel.self)` - Shared app state
 - `@State private var sidebarViewModel` - Sidebar-specific state management

 ### Computed Properties

 #### traitsFilter: [Filter]
 Transforms traits into Filter objects:
 - **Groups traits by name** using Dictionary grouping
 - **Sorts alphabetically** by trait name
 - **Creates Filter instances** with trait metadata

 ## List Structure

 ### Section 1: Smart Filters
 - **Dynamic filters** from viewModel.smartFilters
 - **NavigationLink navigation** with filter selection
 - **System icons** for visual identification

 ### Section 2: Traits
 - **Trait-based filters** from traitsFilter
 - **Character count badges** showing usage
 - **Context menu** with delete/rename options
 - **Accessibility support** with inflected character counts
 - **Swipe-to-delete** functionality

 ## Toolbar Actions

 ### Debug Tools (DEBUG only)
 - **Sample data insertion** - Adds test traits for development

 ### Production Tools
 - **Awards button** - Shows awards sheet with "rosette" icon
 - **Add trait button** - Creates new traits with incremental naming

 ## Modal Presentations

 ### Rename Alert
 - **Text field input** for new trait name
 - **OK/Cancel buttons** with completion handling
 - **Bound to sidebarViewModel** state

 ### Awards Sheet
 - **Presents AwardsView** in sheet format
 - **Controlled by sidebarViewModel.showingAwards**

 ## Extension Functions
Swift Data related
 
 ### deleteTraits(_ offsets: IndexSet)
 Comprehensive trait deletion:
 1. **Removes trait references** from all characters
 2. **Deletes trait instances** from SwiftData context
 3. **Maintains data integrity** during deletion

 ### countCharactersWithTrait(traitName: String) -> Int
 Counts characters associated with specific trait name.

 ### delete(_ filter: Filter)
 Deletes individual trait via Filter object.

 */
struct SidebarView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(ViewModel.self) private var viewModel
    @Query var characters: [Character]
    @Query var traits: [Traits]
    
    @State private var sidebarViewModel = SidebarViewModel()
    
    // build a list of Filter out of traits
    var traitsFilter: [Filter] {
        let grouped = Dictionary(grouping: traits) { $0.name }
        let sortedGrouped = grouped.sorted { $0.key < $1.key }
        
        return sortedGrouped.map { name, traits in
            Filter(id: traits.first!.id, name: name, icon: "tag", trait: traits.first!)
        }
    }
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        List(selection: $viewModel.selectedFilter) {
            Section("Smart filters") {
                ForEach(viewModel.smartFilters!) { filter in
                    NavigationLink(value: filter) {
                        Label(filter.name, systemImage: filter.icon)
                    }
                }
            }
            
            Section("Traits") {
                ForEach(traitsFilter) { filter in
                    NavigationLink(value: filter) {
                        Label(filter.name, systemImage: filter.icon)
                            .badge(countCharactersWithTrait(traitName: filter.name))
                            .contextMenu {
                                Button(role: .destructive) {
                                    delete(filter)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                
                                Button {
                                    guard let traitSelected = traits.first(where: { $0.name == filter.name }) else { return }
                                    sidebarViewModel.renameTrait(traitSelected)
                                } label: {
                                    Label("Rename", systemImage: "pencil")
                                }
                            }
                            .accessibilityElement()
                            .accessibilityLabel(filter.name)
                            .accessibilityHint("^[\(countCharactersWithTrait(traitName: filter.name)) character](inflect: true)")
                    }
                }.onDelete(perform: deleteTraits)
            }
        }
        .toolbar {
            // will not be in production
        #if DEBUG
            Button {
                modelContext.insert(Traits(name: "New Trait"))
                modelContext.insert(Traits(name: "New Trait2"))
                modelContext.insert(Traits(name: "New Trait3"))
            } label: {
                Label("Add samples", systemImage: "key")
            }
        #endif
            
            Button {
                sidebarViewModel.showingAwards.toggle()
            } label: {
                Label("Show awards", systemImage: "rosette")
            }
            
            Button {
                // Find the highest "New Trait" number
                let highestNumber = traits.compactMap { trait -> Int? in
                    if trait.name == "New Trait" { return 0 }
                    if trait.name.hasPrefix("New Trait") {
                        return Int(String(trait.name.dropFirst("New Trait".count)))
                    }
                    return nil
                }.max() ?? -1
                let nextName = highestNumber == -1 ? "New Trait" : "New Trait\(highestNumber + 1)"
                modelContext.insert(Traits(name: nextName))
            } label: {
                Label("Add samples", systemImage: "plus")
            }
        }
        .navigationTitle("Filters")
        .alert("Rename Character", isPresented: $sidebarViewModel.isRenamingTag) {
            Button("OK") { sidebarViewModel.completeRename(traits: traits) }
            Button("Cancel", role: .cancel) {}
            TextField("New Name", text: $sidebarViewModel.newTagName)
        }
        .sheet(isPresented: $sidebarViewModel.showingAwards) {
            AwardsView()
        }
    }
}

extension SidebarView {
    // All functions that depend on SwiftData
    
    func deleteTraits(_ offsets: IndexSet) {
        for offset in offsets {
            let traitName = traitsFilter[offset].name
            
            // 1. Safely delete trait references from characters
            for character in characters {
                // Only attempt to modify traitsList if it exists
                if var traits = character.traitsList {
                    traits.removeAll { $0.name == traitName }
                    character.traitsList = traits
                }
            }
            
            // 2. Delete all Trait instances with matching name
            for trait in traits where trait.name == traitName {
                modelContext.delete(trait)
            }
        }
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
    
    func delete(_ filter: Filter) {
        guard let trait = filter.trait else { return }
        modelContext.delete(trait)
    }
}

#Preview {
    let preview = Preview(Traits.self)
    preview.addSamples(Traits.exampleTraits)
    
    return  SidebarView()
        .modelContainer(preview.container)
        .environment(ViewModel())
}
