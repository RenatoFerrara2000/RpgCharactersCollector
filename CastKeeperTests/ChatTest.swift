//
//  ChatTest.swift
//  CastKeeper
//
//  Created by Renato Ferrara on 29/08/25.
//

import Testing
import SwiftData
@testable import CastKeeper


struct ChatTest {
    
    
    @Test("SendMessage throws error for empty prompt") func testSendMessageEmptyPrompt() async throws {
        let chatService = ApiClient(apiKey: "test-key") // Your original class
        await #expect(throws: ChatError.emptyPrompt) {
            try await chatService.sendMessage("", messages: [], instructions: "Test")
        }
    }
    
    @Test("Test with real API")
    func testRealAPIIntegration() async throws {
        // GIVEN
        let chatService = ApiClient(apiKey: "\(Secrets.$apiKeyCl)")
        
        // WHEN
        let result = try await chatService.sendMessage(
            "Say 'Hello, World!' and nothing else.",
            messages: [],
            instructions: "You are a helpful assistant. Follow instructions exactly."
        )
        
        // THEN
        #expect(result.isAI == true)
        #expect(result.text.contains("Hello, World!"))
        #expect(!result.id.isEmpty)
    }
    
    
    
}
