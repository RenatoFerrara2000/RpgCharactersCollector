//
//  ExampleAppApp.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 28/04/25.
//

import SwiftUI
import SwiftData

/**
 # CastKeeper App Documentation

 ## Overview

 Main app entry point for CastKeeper

 ## CastKeeper

 Main app struct that defines the application structure and configuration.

 ## Architecture

 ### Navigation Structure
 - **Three-pane layout** using `NavigationSplitView`
   - **Sidebar:** `SidebarView()` - Primary navigation
   - **Content:** `ContentView()` - Main content area
   - **Detail:** `DetailView()` - Detail/secondary content

 ### Data Management
 - **SwiftData integration** with `modelContainer` for persistent storage
 - **Managed types:** `Character` and `Traits` models
 - **Shared state** via `ViewModel` injected into environment

 ### State Management
 - `@State private var viewModel = ViewModel()` - App-level view model
 - Environment injection makes ViewModel accessible to all child views

 */
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
