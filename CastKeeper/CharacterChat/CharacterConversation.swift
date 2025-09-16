//
//  CharacterConversation.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 30/06/25.
//
import SwiftUI
/**
## Overview

 SwiftUI view that provides a chat interface for conversations with a specific character, featuring message display and input controls.

 ### Layout Structure
 - **Section** with "Chat" header
 - **VStack** containing message list and input area
 - **List** for message display  
 - **HStack** for text input and send button

 ### Message Display
 Each message shows:
 - **Icon indication:**
   - AI messages: `figure.fencing` (blue)
   - User messages: `person` (green)
 - **Message text** with leading padding

 ### Input Controls
 - **TextField** with rounded border style
 - **Send button** (disabled based on `canSendMessage` state)
 - **Submit actions** on both Return key and button tap
 - **Input validation** through ViewModel

 ## State Management
 - `@State private var viewModel` - Manages messages and input state
 - `character: Character` - Required character parameter for conversation context
 - Message sending triggered via `viewModel.sendChatMessage(char: character)`

 */
struct CharacterConversation: View {
    @State private var viewModel = CharacterConversationViewModel()
    var character: Character
 
    var body: some View {
        Section("Chat") {
            VStack(spacing: 0) {
                List(viewModel.messages) { message in
                    HStack {
                        if message.isAI {
                            Image(systemName: "figure.fencing")
                                .foregroundColor(.blue)
                        } else {
                            Image(systemName: "person")
                                .foregroundColor(.green)
                        }
                        Text(message.text)
                            .padding(.leading, 8)
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
                .frame(minHeight: 200)
                
                HStack {
                    TextField("Write Something", text: $viewModel.messageText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button {
                        viewModel.sendChatMessage(char: character)
                    } label: {
                        Text("Send")
                    }
                    .disabled(!viewModel.canSendMessage)
                }
                .padding()
            }
        }
    }
}

#Preview {
    CharacterConversation(character: .exampleCharacters[0])
}
