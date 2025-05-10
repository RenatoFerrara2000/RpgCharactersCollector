//
//  NoCharacterView.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 07/05/25.
//

import SwiftUI

struct NoCharacterView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(ViewModel.self) private var viewModel
    
    var body: some View {
        Text("No character selected")
            .font(.title)
        
        Button("Add Character") {
         
        }
    }
}

#Preview {
    NoCharacterView()
        .environment(ViewModel())
}
