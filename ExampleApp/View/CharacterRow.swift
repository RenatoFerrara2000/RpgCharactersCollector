//
//  CharacterRow.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 06/05/25.
//

import SwiftUI

struct CharacterRow: View {
    @Environment(\.modelContext) var modelContext
    
    var character: Character
    var body: some View {
        
        NavigationLink(value: character) {
            HStack{
                
                
                Image(systemName: "figure.fencing")
                    .imageScale(.large)
                
                VStack(alignment: .leading){
                    Text(character.name)
                        .font(.headline)
                        .lineLimit(1)
                
                    ForEach(character.traitsList ?? []){ trait in
                        Text(trait.name)
                    }
                    .lineLimit(1)
                    
                    
                }
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(character.creationDate.formatted(date: .numeric, time: .omitted))
                        .font(.subheadline)
                }
            }
        }
    }
    
}

#Preview {
    CharacterRow(character: .example)
}
