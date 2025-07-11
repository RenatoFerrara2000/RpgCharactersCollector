//
//  ExampleAppApp.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 28/04/25.
//

import SwiftUI
import SwiftData

@main
struct CastKeeper: App {
    @State private var viewModel = ViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                SidebarView(selectedFilter: $viewModel.selectedFilter)
            } content: {
                ContentView(selectedCharacter: $viewModel.selectedCharacter)
            } detail: {
                DetailView(selectedCharacter: viewModel.selectedCharacter)
            }
            .modelContainer(for: Character.self)
            .environment(viewModel)
          }
    }
}
