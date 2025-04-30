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
                       }}
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
}

#Preview {
    SidebarView(selectedFilter: .constant(nil))
 }
