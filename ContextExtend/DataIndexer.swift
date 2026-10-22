import CoreSpotlight
import Foundation
import AppIntents

enum DataIndexer {
    static func index(_ model: DataModel) async throws {
        let entity = DataEntity(model: model)

        try await CSSearchableIndex.default()
            .indexAppEntities([entity])
    }

    static func remove(_ id: UUID) async throws {
        try await CSSearchableIndex.default()
            .deleteAppEntities(
                identifiedBy: [id],
                ofType: DataEntity.self
            )
    }

    static func indexAll() async throws {
        let models = try DataStore.all()
        try await CSSearchableIndex.default()
            .indexAppEntities(models.map(DataEntity.init(model:)))
    }
}
