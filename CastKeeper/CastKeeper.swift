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
                SidebarView()
            } content: {
                ContentView()
            } detail: {
                DetailView()
            }
            .modelContainer(for: [Character.self, Traits.self] )
            .environment(viewModel)
          }
    }
}
