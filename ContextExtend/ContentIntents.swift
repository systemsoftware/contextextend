import AppIntents

@available(iOS 27.0, macOS 27.0, visionOS 27.0, *)
@AppIntent(schema: .system.open)
struct OpenContentIntent: OpenIntent {
    static let title: LocalizedStringResource = "Open Content"

    @Parameter(title: "Content")
    var target: DataEntity

    func perform() async throws -> some IntentResult {
        await NavigationState.shared.open(target.id)
        return .result()
    }
}

@available(iOS 27.0, macOS 27.0, visionOS 27.0, *)
@AppIntent(schema: .system.searchInApp)
struct SearchContentInAppIntent: ShowInAppSearchResultsIntent {
    static let title: LocalizedStringResource = "Search ContextExtend"
    static let searchScopes: [StringSearchScope] = [.general]

    var criteria: StringSearchCriteria

    func perform() async throws -> some IntentResult {
        await NavigationState.shared.search(criteria.term)
        return .result()
    }
}

struct FindContentIntent: AppIntent {
    static let title: LocalizedStringResource = "Find Content"
    static let description = IntentDescription("Search saved content in ContextExtend.")
    static let openAppWhenRun = true

    @Parameter(title: "Search Term")
    var searchTerm: String

    static var parameterSummary: some ParameterSummary {
        Summary("Find \(\.$searchTerm) in ContextExtend")
    }

    func perform() async throws -> some IntentResult {
        await NavigationState.shared.search(searchTerm)
        return .result()
    }
}

struct ContextExtendShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: FindContentIntent(),
            phrases: [
                "Find content in \(.applicationName)",
                "Search \(.applicationName)"
            ],
            shortTitle: "Find Content",
            systemImageName: "magnifyingglass"
        )
    }
}
