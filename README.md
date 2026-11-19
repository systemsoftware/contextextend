# Context Extend

Context Extend makes your own text available as context for natural-language conversations with Siri on iOS 27. Save a packing list, meeting notes, or text from a PDF, then ask Siri about the details you saved.

## How Siri uses your saved content

When you save an item, Context Extend uses the App Intents Notes schema to represent it as a note and indexes its name, description, and text in Spotlight on your device. Siri with Apple Intelligence can use Spotlight’s semantic search to find relevant content based on how you describe it and draw on the saved text to answer a question. [Apple’s guide to App Intents and Siri](https://developer.apple.com/documentation/appintents/apple-intelligence-and-siri-ai)

To try it, save an item with a descriptive name and ask a question that refers to the item or what it contains.

| Save in Context Extend | Try asking Siri |
| --- | --- |
| **Camping Packing List**, with your gear checklist | “What cooking gear is on my camping packing list?” |
| **Kitchen Renovation Notes**, with materials and decisions | “Which countertop material did we pick for the kitchen?” |

## Other features

- Save typed or pasted text, or import text from a PDF or readable text file. The app saves the extracted text from imported files.
- Search saved items by name, description, or content.
- Saved items are also available through Spotlight and Shortcuts.
- Sync saved items across devices through your private iCloud database when iCloud sync is active.

## Build and run

1. Open `ContextExtend.xcodeproj` in Xcode with SDK support for your target platform. The project targets iOS, iPadOS, macOS, and visionOS 27.0 or later.
2. Select the **ContextExtend** scheme and choose a run destination.
3. If you're building with a different Apple developer team, update **Signing & Capabilities** with your team, a unique bundle identifier, and a CloudKit container registered to your team.
4. Press **⌘R** to build and run. Use the **+** button to save your first item.

## Privacy and terms

- [Privacy Policy](privacy.html)
- [Terms of Use](tos.html)

## License

The source code is available under the [MIT License](LICENSE). The app icon incorporates [Google Material Icons](https://fonts.google.com/icons) licensed under the [Apache License 2.0](https://github.com/google/material-design-icons/blob/master/LICENSE).
