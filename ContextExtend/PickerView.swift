import SwiftUI
import UniformTypeIdentifiers

struct FilePickerView: View {
    @State private var isImporterPresented = false
    @State private var selectedFileName: String = "No file chosen"
    
    @Binding var selectedContent: String

    var body: some View {
        VStack(spacing: 16) {
            Text(selectedFileName)

            Button("Select File") {
                isImporterPresented = true
            }
            .fileImporter(
                isPresented: $isImporterPresented,
                allowedContentTypes: [.item],
                allowsMultipleSelection: false
            ) { result in
                do {
                    guard let selectedURL = try result.get().first else { return }
                    
                    let gotAccess = selectedURL.startAccessingSecurityScopedResource()
                    defer {
                        if gotAccess {
                            selectedURL.stopAccessingSecurityScopedResource()
                        }
                    }
                    
                    selectedFileName = selectedURL.lastPathComponent
                    
                    selectedContent = extractText(from: selectedURL) ?? "Failed to read"
                } catch {
                    print("Error selecting file: {error.localizedDescription}")
                }
            }
        }
        .padding()
    }
}
