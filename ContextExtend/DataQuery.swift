import AppIntents
import CoreSpotlight

struct DataQuery: EntityStringQuery, IndexedEntityQuery {
    func entities(
        for ids: [DataEntity.ID]
    ) async throws -> [DataEntity] {
        try await DataStore.find(ids: ids).map {
            DataEntity(model: $0)
        }
    }

    func suggestedEntities() async throws -> [DataEntity] {
        try await DataStore.all().map {
            DataEntity(model: $0)
        }
    }

    func entities(matching string: String) async throws -> [DataEntity] {
        try await DataStore.matching(string).map(DataEntity.init(model:))
    }

    func reindexEntities(
        for identifiers: [DataEntity.ID],
        indexDescription: CSSearchableIndexDescription
    ) async throws {
        let entities = try await entities(for: identifiers)
        try await CSSearchableIndex.default().indexAppEntities(entities)
    }

    func reindexAllEntities(indexDescription: CSSearchableIndexDescription) async throws {
        let entities = try await suggestedEntities()
        try await CSSearchableIndex.default().indexAppEntities(entities)
    }
}
