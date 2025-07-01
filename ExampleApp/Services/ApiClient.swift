//
//  ApiClient.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 30/06/25.
//

import Foundation

struct ApiClient {
    var apiKey: String
    
    func generateText(
        from prompt: String,
        instructions: String,
        conversationHistory: [Message] = []
    ) async throws -> (id: String, message: String) {
        let url = URL(string: "https://api.anthropic.com/v1/messages")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json" , forHTTPHeaderField: "Content-Type")
        
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
        
        var systemMessage = instructions

        
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
        
        request.httpBody =  try JSONSerialization.data(withJSONObject: requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse,
                 httpResponse.statusCode != 200 {
                  throw APIError.httpError(httpResponse.statusCode)
              }
         
        let claudeResponse = try JSONDecoder().decode(ClaudeResponse.self, from: data)
        
        
        let responseText = claudeResponse.content.first?.text ?? ""

        return (claudeResponse.id, responseText)
              }
}

enum APIError: Error {
    case httpError(Int)
    case decodingError
    case networkError
}

