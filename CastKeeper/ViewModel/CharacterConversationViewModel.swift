//
//  CharacterConversationViewModel.swift
//  CastKeeper
//
//  Created by Renato Ferrara on 16/07/25.
//
import SwiftUI

extension CharacterConversation {
    @Observable
    @MainActor // TO REVIEW
    class CharacterConversationViewModel {
         var messages = [Message]()
           var messageText = ""
        
     var client = ApiClient(apiKey: " NOOOOO")
        
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
                    let response = try await client.sendMessage(prompt, messages: messages.dropLast(), instructions:  buildCharacterInstructions(character: char))
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
