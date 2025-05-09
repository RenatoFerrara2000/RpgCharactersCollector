//
//  ExampleAppApp.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 28/04/25.
//

import SwiftUI
import SwiftData

@main
struct ExampleAppApp: App {
    @State private var viewModel = ViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                SidebarView(selectedFilter: $viewModel.selectedFilter)
            } content: {
                ContentView(selectedCharacter: $viewModel.selectedCharacter)
            } detail: {
                DetailView( )
            }
            .modelContainer(for: CharacterModel.self)
            .environment(viewModel)


          }
    }
}
