//
//  CharacterView.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 07/05/25.
//
import SwiftUI
import SwiftData
/**
 # Overview

 SwiftUI form-based view for displaying and editing character details, including basic information, traits, description, and chat functionality.

 ## Architecture

 ### Form Structure
 Three main sections organized in a Form layout:

 1. **Character Info Section**
 2. **Description Section**
 3. **Conversation Section**

 ### Data Management
 - `@State var character` - Editable character instance
 - `@Environment(\.modelContext)` - SwiftData context
 - `@Query var allTraits` - All available traits from database

 ## Form Sections

 ### Section 1: Character Information
 - **Name field:** Title font, bound to `character.name`
 - **Role field:** Bound to `character.role`
 - **Timestamp display:** Shows creation or modification date (long date, short time)
 - **Trait management:** `CharacterTraitList` component for trait selection

 ### Section 2: Description
 - **Section header:** "Description" in title2 font (secondary color)
 - **Description field:** Multiline text bound to `character.characterDescription`

 ### Section 3: Conversation
 - **Chat interface:** `CharacterConversation` component
 - **Interactive messaging** with the character

 */
struct CharacterView: View {
    @State  var character: Character
    @Environment(\.modelContext) var modelContext
    @Query var allTraits: [Traits]
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    TextField("Character name", text: $character.name, prompt: Text("Enter the character name"))
                        .font(.title)
                    
                    TextField("Role", text: $character.role, prompt: Text("Enter the character role"))
                    
                    if character.modificationDate == nil {
                        Text("**Created:** \(character.creationDate.formatted(date: .long, time: .shortened))")
                            .foregroundStyle(.secondary)
                    } else {
                        Text("**Modified:** \(character.modificationDate!.formatted(date: .long, time: .shortened))")
                            .foregroundStyle(.secondary)
                    }
                    CharacterTraitList(character: character, allTraits: allTraits)
                }
            }
            
            Section {
                VStack(alignment: .leading) {
                    Text("Description")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    
                    TextField("Description", text: $character.characterDescription, prompt: Text("Enter Character Description"))
                }
            }
            Section {
                CharacterConversation(character: character )
            }
        }
    }
}
#Preview {
    CharacterView(character: .exampleCharacters[0])
        .environment(ViewModel())
}
