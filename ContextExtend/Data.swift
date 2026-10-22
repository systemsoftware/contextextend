import SwiftData
import Foundation
import AppIntents
import Foundation

@Model
final class DataModel {
    var id: UUID = UUID()

    var name: String = ""
    var contentDescription: String = ""
    var content: String = ""

    init(
        id: UUID = UUID(),
        name: String,
        contentDescription: String,
        content: String
    ) {
        self.id = id
        self.name = name
        self.contentDescription = contentDescription
        self.content = content
    }
}

