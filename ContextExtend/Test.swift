
import CoreSpotlight
import UniformTypeIdentifiers

func testLegacyIndexing() async throws {
    let attributes = CSSearchableItemAttributeSet(
        contentType: .plainText
    )

    attributes.title = "Test Document"
    attributes.displayName = "Test Document"
    attributes.textContent =
        "The secret meeting location is Willow 9876."

    let item = CSSearchableItem(
        uniqueIdentifier: "context-extend-test-1",
        domainIdentifier: "ContextExtendTests",
        attributeSet: attributes
    )

    try await CSSearchableIndex.default()
        .indexSearchableItems([item])
}



func testActualEntity() async {
    let query = CSSearchQuery(
        queryString: #"textContent == "Cedar*""#,
        attributes: ["title", "textContent"]
    )

    do {
        for try await result in query.results {
            print("Found:", result.item.uniqueIdentifier)
            print("Title:", result.item.attributeSet.title ?? "nil")
        }
    } catch {
        print("Error:", error)
    }
}
