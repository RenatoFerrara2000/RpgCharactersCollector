//
//  ExampleAppApp.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 28/04/25.
//

import SwiftUI
import SwiftData

@main
struct ExampleAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: CharacterModel.self)
        }
    }
}
