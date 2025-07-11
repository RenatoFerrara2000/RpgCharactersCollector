//
//  Message.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 30/06/25.
//


import Foundation

struct Message: Identifiable, Equatable {
    var id = UUID().uuidString
    var text: String
    var isAI: Bool
    var timestamp = Date.now
}
