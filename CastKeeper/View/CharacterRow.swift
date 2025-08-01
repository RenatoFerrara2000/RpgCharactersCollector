//
//  CharacterRow.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 06/05/25.
//

import SwiftUI
/**
 # Overview

 SwiftUI view that displays a character in a row format with navigation support, showing character details in a structured layout.

 ## Layout Structure

 ### NavigationLink Container
 - **Value-based navigation** using character as navigation value
 - **Tappable row** for navigation to character details

 ### Content Layout (HStack)
 1. **Icon section:**
    - `figure.fencing` system image (large scale)

 2. **Character info (VStack, leading aligned):**
    - **Name:** Headline font, single line limit
    - **Traits list:** Displays all character traits, single line limit each

 3. **Date section (VStack, trailing aligned):**
    - **Creation date:** Abbreviated format, subheadline font
    - **Accessibility support** with formatted date label
 
 */
struct CharacterRow: View {
    @Environment(\.modelContext) var modelContext
    
    var character: Character
    var body: some View {
        NavigationLink(value: character) {
            HStack {
                Image(systemName: "figure.fencing")
                    .imageScale(.large)
                
                VStack(alignment: .leading) {
                    Text(character.name)
                        .font(.headline)
                        .lineLimit(1)
                
                    ForEach(character.traitsList ?? []) { trait in
                        Text(trait.name)
                    }
                    .lineLimit(1)
                }
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(character.creationDate.formatted(date: .abbreviated, time: .omitted))
                        .accessibilityLabel(character.creationDate.formatted(date: .abbreviated, time: .omitted))
                        .font(.subheadline)
                }
            }
        }
    }
}

#Preview {
    CharacterRow(character: .exampleCharacters[0])
}
