//
//  PreviewContainer.swift
//  CastKeeper
//
//  Created by Renato Ferrara on 16/07/25.
//
import Foundation
import SwiftData

@MainActor //to quickly fix data racing errors 
struct Preview {
    let container: ModelContainer
    
    init() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        
        do {
            container = try ModelContainer(for: Character.self, configurations: config)
        } catch {
            fatalError("Could not create  preview container")
        }
    }
    
    func addSamples(_ examples: [Character] ){
              Task {
                 examples.forEach { char in
                     container.mainContext.insert(char)
            }
        }
    }
}
