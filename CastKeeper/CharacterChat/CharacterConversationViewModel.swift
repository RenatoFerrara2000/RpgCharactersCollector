//
//  CharacterConversationViewModel.swift
//  CastKeeper
//
//  Created by Renato Ferrara on 16/07/25.
//
import SwiftUI

/**
 # CharacterConversationViewModel Documentation

 ## Overview

 Observable view model that manages chat conversations with AI characters, handling message state, API communication, and dynamic character instruction generation.

 ## CharacterConversationViewModel

 Main-actor bound state management for character chat functionality.
 
 ## Properties

 ### State Properties
 - `messages: [Message]` - Conversation history array
 - `messageText: String` - Current input text
 - `client: ApiClient` - API client with secret key injection

 ### Computed Properties
 - `canSendMessage: Bool` - Validates non-empty trimmed input

 ## Core Methods

 ### buildCharacterInstructions(character: Character) -> String
 Generates dynamic system instructions for AI roleplay:

 **Character Information:**
 - Name (with fallback to "Unknown Character")
 - Role (with fallback to "No specific role")
 - Description (with fallback to "No description provided")
 - Traits list (comma-separated if available)

 **Built-in Guidelines:**
 - Stay in character consistently
 - Respond based on character attributes
 - Maintain conversational engagement
 - Child-safe content enforcement
 - Character identity reinforcement
 - Background-informed responses

 ### sendChatMessage(char: Character)
 Handles complete message sending workflow:

 1. **Input Processing:**
    - Captures current `messageText`
    - Clears input field immediately
    - Adds user message to conversation with animation

 2. **API Communication:**
    - Sends request with character instructions
    - Excludes latest user message from context (uses `dropLast()`)
    - Handles async/await pattern with Task

 3. **Response Handling:**
    - Appends AI response with animation
    - Error logging for debugging

 ### Error Handling
 - Basic error logging to console
 - Graceful failure without UI disruption

 */
extension CharacterConversation {
    @Observable
    @MainActor // TODO: Check if is actually needed
    class CharacterConversationViewModel {
        var messages = [Message]()
        var messageText = ""
        
        var client = ApiClient(apiKey: "\(Secrets.$apiKeyCl)")
        
        var canSendMessage: Bool {
            !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        
        func buildCharacterInstructions(character: Character) -> String {
            var instructions = """
            You are roleplaying as a character named "\(character.name.isEmpty ? "Unknown Character" : character.name)".
            Character Details:
            - Name: \(character.name.isEmpty ? "Unknown" : character.name)
            - Role: \(character.role.isEmpty ? "No specific role" : character.role)
            - Description: \(character.characterDescription.isEmpty ? "No description provided" : character.characterDescription)
            """
            
            // Add traits if they exist
            if let traits = character.traitsList, !traits.isEmpty {
                let traitNames = traits.compactMap { $0.name }.joined(separator: ", ")
                instructions += "\n- Key Traits: \(traitNames)"
            }
            
            instructions += """
                
                IMPORTANT GUIDELINES:
                - Stay in character at all times
                - Respond as this character would, based on their description, role, and traits
                - Keep responses conversational and engaging
                - You may be addressing minors, so never use or tolerate offensive language
                - If asked about your identity, you are this character, not an AI
                - Draw from the character's background to inform your responses
                """
            
            return instructions
        }
        
        func sendChatMessage(char: Character) {
            let prompt = messageText
            messageText = ""
            withAnimation {
                messages.append(Message(text: prompt, isAI: false))
            }
            Task {
                do {
                    let response = try await client.sendMessage(prompt, messages: messages.dropLast(), instructions: buildCharacterInstructions(character: char))
                    withAnimation {
                        messages.append(response)
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}
