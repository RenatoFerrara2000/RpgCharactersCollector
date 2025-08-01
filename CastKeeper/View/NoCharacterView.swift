//
//  NoCharacterView.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 07/05/25.
//

import SwiftUI
/**
 # Overview

 SwiftUI view that displays an empty state when no character is selected, providing a quick action to create a new character.

 ## NoCharacterView

 Empty state view with character creation functionality.

 ## Architecture

 ### Layout Structure
 - **VStack** containing message and action button
 - **Centered content** for empty state presentation

 ### Content Elements
 - **Title text:** "No character selected" in title font
 - **Action button:** "New Character" with prominent bordered style

 ## Functionality

 ### Character Creation
 Button action creates and selects new character:
 1. **Creates character** with default values:
    - Name: "New Character"
    - Description: Empty string
    - Role: Empty string
 2. **Inserts into SwiftData** context
 3. **Auto-selects** newly created character via `viewModel.selectedCharacter`

 ## State Management
 - `@Environment(\.modelContext)` - SwiftData persistence context
 - `@Environment(ViewModel.self)` - Shared view model for selection state
 
 */
struct NoCharacterView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(ViewModel.self) private var viewModel
    
    var body: some View {
        VStack {
            Text("No character selected")
                .font(.title)
            
            Button("New Character") {
                let char = Character(name: "New Character", characterDescription: "", role: "")
                modelContext.insert(char)
                
                // Set the newly created character as selected
                viewModel.selectedCharacter = char
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
#Preview {
    NoCharacterView()
}
