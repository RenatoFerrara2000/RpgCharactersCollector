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
        traits.map { trait in
            Filter(id: trait.id, name: trait.name, icon: "tag", tag: trait)
            
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
                   ForEach(traitsFilter){ filter in
                       NavigationLink(value: filter){
                           Label(filter.name, systemImage: filter.icon)
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
            .environment(ViewModel())
}
