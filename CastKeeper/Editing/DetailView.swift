//
//  DetailView.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 30/04/25.
//

import SwiftUI
import SwiftData
/**
 # DetailView Documentation

 ## Overview

 SwiftUI view that displays character details in the detail pane of a NavigationSplitView, showing either character information or an empty state.

 ## DetailView

 Detail pane view with conditional character display.

 ## Architecture

 ### Conditional Display
 - **With selection:** Shows `CharacterView(character:)` for selected character
 - **No selection:** Shows `NoCharacterView()` as empty state

 ### Navigation Configuration
 - **Title:** "Detail View"
 - **Display mode:** Inline (compact header)

 ## State Management
 - `@Environment(ViewModel.self)` - Accesses shared view model
 - `viewModel.selectedCharacter` - Optional character for conditional rendering

 */
struct DetailView: View {
    @Environment(ViewModel.self) private var viewModel
    
    var body: some View {
        VStack {
            if let character = viewModel.selectedCharacter {
                CharacterView(character: character)
            } else {
                NoCharacterView()
            }
        }
        .navigationTitle("Detail View")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DetailView()
        .environment(ViewModel())
}
