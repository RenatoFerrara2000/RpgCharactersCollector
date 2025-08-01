//
//  Message.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 30/06/25.
//

import Foundation
// swiftlint:disable all
/**
Message
Represents a chat message in the conversation.

 ## Properties
 - ` id` - Unique identifier (auto-generated UUID)
 - `text` - Message content
 - ` isAI` - True if from AI, false if from user
 - ` timestamp` - When the message was created
 */
// swiftlint:enable all

struct Message: Identifiable, Equatable {
    var id = UUID().uuidString
    var text: String
    var isAI: Bool
    var timestamp = Date.now
}
