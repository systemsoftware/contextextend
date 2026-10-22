import Foundation
import Observation

@MainActor
@Observable
final class NavigationState {
    static let shared = NavigationState()

    var path: [UUID] = []
    var searchText = ""

    func open(_ id: UUID) {
        searchText = ""
        path = [id]
    }

    func search(_ text: String) {
        path = []
        searchText = text
    }
}
