import AppIntents

@available(iOS 27.0, macOS 27.0, visionOS 27.0, *)
@AppEntity(schema: .notes.account)
struct NoteAccountEntity {
    static let defaultQuery = NoteAccountQuery()

    let id: UUID
    var name: String

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
}

struct NoteAccountQuery: EntityQuery {
    func entities(for identifiers: [UUID]) async throws -> [NoteAccountEntity] { [] }
}

@available(iOS 27.0, macOS 27.0, visionOS 27.0, *)
@AppEntity(schema: .notes.folder)
struct NoteFolderEntity {
    static let defaultQuery = NoteFolderQuery()

    let id: UUID
    var name: String
    var parentFolder: NoteFolderEntity?
    var account: NoteAccountEntity?

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
}

struct NoteFolderQuery: EntityQuery {
    func entities(for identifiers: [UUID]) async throws -> [NoteFolderEntity] { [] }
}
