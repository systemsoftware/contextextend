import AppIntents
import CoreSpotlight
import UniformTypeIdentifiers

@available(iOS 27.0, macOS 27.0, visionOS 27.0, *)
@AppEntity(schema: .notes.note)
struct DataEntity: IndexedEntity {
    static var defaultQuery = DataQuery()

    let id: UUID

    var name: AttributedString

    @Property(title: "Description")
    var contentDescription: String

    var content: AttributedString?
    var attachments: [IntentFile]
    var isPinned: Bool
    var creationDate: Date?
    var modificationDate: Date?
    var folder: NoteFolderEntity?

    init(model: DataModel) {
        self.id = model.id
        self.name = AttributedString(model.name)
        self.contentDescription = model.contentDescription
        self.content = AttributedString(model.content)
        self.attachments = []
        self.isPinned = false
        self.creationDate = nil
        self.modificationDate = nil
        self.folder = nil
    }

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(String(name.characters))",
            subtitle: "\(contentDescription)"
        )
    }

    var attributeSet: CSSearchableItemAttributeSet {
        let attributes = CSSearchableItemAttributeSet(
            contentType: UTType.text
        )

        attributes.title = String(name.characters)
        attributes.contentDescription = contentDescription
        attributes.textContent = content.map { String($0.characters) }
        attributes.keywords = ["ContextExtend"]

        return attributes
    }
}
