//
//  ApiClient.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 30/06/25.
//

import Foundation
// swiftlint:disable all
/**
 # ApiClient Documentation

 ## Overview

 The `ApiClient` struct provides a Swift interface for communicating with the Anthropic Claude API. It handles message sending, conversation history management, and error handling for chat-based interactions with Claude AI models.

 ## Core Components

 ### ApiClient

 The main client struct that manages API communication with the Anthropic Claude service.

 #### Properties

 - `apiKey: String` -  Anthropic API key for authentication

 #### Methods

 ##### sendMessage

 Sends a message to Claude and returns the AI response as a `Message` object.

 ```swift
 func sendMessage(_ prompt: String, messages: [Message], instructions: String) async throws -> Message
 ```

 **Parameters:*
 - `prompt: String` - The user's message/question to send to Claude
 - `messages: [Message]` - Array of previous conversation messages for context
 - `instructions: String` - System instructions that define Claude's behavior and role

 **Returns:**
 - `Message` - A message object containing Claude's response with a unique ID

 **Throws:**
 - `ChatError.emptyPrompt` - When the prompt is empty or contains only whitespace
 - `HTTPError` - For various HTTP-related errors (authentication, rate limits, server errors)

 ##### generateText

 Lower-level method that handles the actual API communication and returns raw response data.

 ```swift
 func generateText(
     from prompt: String,
     instructions: String,
     conversationHistory: [Message] = []
 ) async throws -> (id: String, message: String)
 ```

 **Parameters:**
 - `prompt: String` - The text prompt to send
 - `instructions: String` - System instructions for the AI
 - `conversationHistory: [Message]` - Optional conversation context (defaults to empty array)

 **Returns:**
 - `(id: String, message: String)` - Tuple containing the response ID and message text

 ## Error Handling

 ### HTTPError

 A structured error type for handling HTTP-related failures.

 ```swift
 struct HTTPError: Error, LocalizedError {
     let statusCode: Int
 }
 ```

 **Error Descriptions:*
 - **401:** "Authentication failed - check your API key"
 - **400:** "Bad request - invalid parameters"
 - **429:** "Rate limit exceeded"
 - **500-599:** "Server error (statusCode)"
 - **Other:** "HTTP error statusCode"

 */
// swiftlint:enable all

struct ApiClient {
    var apiKey: String
    
    func sendMessage(_ prompt: String, messages: [Message], instructions: String) async throws -> Message {
        let trimmedPrompt = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard prompt.isEmpty == false else {throw ChatError.emptyPrompt}
        let response = try await generateText(
            from: trimmedPrompt,
            instructions: instructions,
            conversationHistory: messages
        )
        
        return Message(id: response.id, text: response.message, isAI: true)
    }
    
    func generateText(
        from prompt: String,
        instructions: String,
        conversationHistory: [Message] = []
    ) async throws -> (id: String, message: String) {
        let url = URL(string: "https://api.anthropic.com/v1/messages")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.setValue("\(apiKey)", forHTTPHeaderField: "X-API-Key")
        
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        
        var messages: [[String: Any]] = []
        
        // Add conversation history (excluding system messages)
        for message in conversationHistory {
            let role = message.isAI ? "assistant" : "user"
            messages.append([
                "role": role,
                "content": message.text
            ])
        }
        
        let systemMessage = instructions
        
        messages.append([
            "role": "user",
            "content": prompt
        ])
        
        let requestBody: [String: Any] = [
            "model": "claude-3-5-haiku-20241022",
            "max_tokens": 1024,
            "messages": messages,
            "system": systemMessage
        ]
        do {
            request.httpBody =  try JSONSerialization.data(withJSONObject: requestBody)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode != 200 {
                throw HTTPError(statusCode: httpResponse.statusCode)
            }
            
            let claudeResponse = try JSONDecoder().decode(ClaudeResponse.self, from: data)
            
            let responseText = claudeResponse.content.first?.text ?? ""
            
            return (claudeResponse.id, responseText)
        }
    }
}

struct HTTPError: Error, LocalizedError {
    let statusCode: Int
    
    var errorDescription: String? {
        switch statusCode {
        case 401:
            return "Authentication failed - check your API key"
        case 400:
            return "Bad request - invalid parameters"
        case 429:
            return "Rate limit exceeded"
        case 500...599:
            return "Server error (\(statusCode))"
        default:
            return "HTTP error \(statusCode)"
        }
    }
}

enum ChatError: Error {
    case emptyPrompt
}
