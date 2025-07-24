//
//  PreviewContainer.swift
//  CastKeeper
//
//  Created by Renato Ferrara on 16/07/25.
//
import Foundation
import SwiftData

@MainActor // to quickly fix data racing errors
struct Preview {
    let container: ModelContainer
    
    init(_ models: any PersistentModel.Type...) {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let schema = Schema(models)
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not create  preview container")
        }
    }
    
    func addSamples(_ examples: [any PersistentModel] ) {
        Task {
            examples.forEach { char in
                container.mainContext.insert(char)
            }
        }
    }
}
