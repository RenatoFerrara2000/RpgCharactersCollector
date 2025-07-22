//
//  TraitsMenuView.swift
//  CastKeeper
//
//  Created by Renato Ferrara on 18/07/25.
//
import SwiftUI

struct TraitsMenuView: View {
    @Environment(ViewModel.self) private var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
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
}


#Preview {
    TraitsMenuView()
    .environment(ViewModel())}
