//
//  CharacterView.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 07/05/25.
//
import SwiftUI
import SwiftData

struct CharacterView: View {
    
    @State  var character: Character
    @Environment(\.modelContext) var modelContext
    @Query var allTraits: [Traits]
    
    var body: some View {
        Form{
            Section{
                VStack(alignment: .leading) {
                    TextField("Character name", text: $character.name, prompt: Text("Enter the character name"))
                        .font(.title)
                    
                    TextField("Role", text: $character.role, prompt: Text("Enter the character role"))
                    
                    if(character.modificationDate == nil)
                    {
                        Text("**Created:** \(character.creationDate.formatted(date: .long, time: .shortened))")
                            .foregroundStyle(.secondary)
                    } else {
                        Text("**Modified:** \(character.modificationDate!.formatted(date: .long, time: .shortened))")
                            .foregroundStyle(.secondary)
                    }
                    TraitMenuView(character: character, allTraits: allTraits)
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
            Section{
                CharacterConversation(character: character )
            }
        }
    }
}


#Preview {
    CharacterView(character: .example)
        .environment(ViewModel())
}
