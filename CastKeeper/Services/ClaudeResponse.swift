//
//  OpenAiResponse.swift
//  ChatterRpg
//
//  Created by Renato Ferrara on 30/06/25.
//

/**
Represents the API response from Claude.
*/
struct ClaudeResponse: Decodable {
    let id: String
    let content: [ClaudeMessageContent]
    
    struct ClaudeMessageContent: Decodable {
        let text: String
    }
}
