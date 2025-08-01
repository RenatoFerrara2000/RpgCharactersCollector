# CastKeeper

A SwiftUI character management app that lets you create, organize, and chat with AI-powered characters using the Anthropic Claude API. Perfect for writers, game masters, and creative storytellers.

**Platform:** iOS 17.0+  
**Swift Version:** 5.9+  
**Frameworks:** SwiftUI, SwiftData

## Prerequisites

- Xcode 15.0 or later
- iOS 17.0+ device or simulator
- Anthropic Claude API key 
- Active internet connection for AI chat features

## Setup

1. Clone the repository
2. Open `CastKeeper.xcodeproj` in Xcode
3.  Write Claude API key in the var client in `CharacterConversationViewModel`
4.  Run!

### 4. **Architecture Choices**
## Architecture

- **MVVM Pattern** with SwiftUI's @Observable
- **SwiftData** for local persistence
- **NavigationSplitView** for iPad-optimized three-pane layout
- **Modular ViewModels** for feature separation

### Known Areas for Improvement
- Error handling could be more robust
- API configuration is currently hardcoded
- Some ViewModels could be further separated for better testability
#### Architecture Improvment
- Due to the current limitations of SwiftData’s @Query property wrapper— which requires data-fetching logic to reside within SwiftUI views—some architectural compromises have been made. While migrating all logic to the ViewModel is a possible alternative, it introduces complexity that may outweigh the benefits within the SwiftData paradigm. In such cases, adopting CoreData might offer a more scalable and testable solution. For now, data-related operations remain in the views to maintain simplicity and alignment with SwiftData’s design constraints.


## Features

- ✅ Create and manage characters with traits
- ✅ AI-powered conversations using Claude API
- ✅ Achievement/awards system
- ✅ SwiftData persistence
- ✅ Accessibility support
- ⚠️ Offline mode (characters only, no AI chat)
