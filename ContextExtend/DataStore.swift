import Foundation
import SwiftData

@MainActor
enum DataStore {
    static let container: ModelContainer = {
        let schema = Schema([DataModel.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to create model container: \(error)")
        }
    }()

    static func find(ids: [UUID]) throws -> [DataModel] {
        let context = container.mainContext

        let models = try context.fetch(
            FetchDescriptor<DataModel>()
        )

        return models.filter { ids.contains($0.id) }
    }

    static func all() throws -> [DataModel] {
        try container.mainContext.fetch(
            FetchDescriptor<DataModel>()
        )
    }

    static func matching(_ text: String) throws -> [DataModel] {
        let term = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !term.isEmpty else { return try all() }
        return try all().filter {
            $0.name.localizedStandardContains(term) ||
            $0.contentDescription.localizedStandardContains(term) ||
            $0.content.localizedStandardContains(term)
        }
    }
}
