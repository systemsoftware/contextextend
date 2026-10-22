//
//  ContentView.swift
//  ContextExtend
//
//  Created by Bryce Agostini on 10/21/26.
//

import SwiftUI
import SwiftData
import AppIntents

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [DataModel]
    @State private var navigation = NavigationState.shared
    @State private var errorMessage: String?

    @State var showAddSheet = false

    @State var newItemName = ""
    @State var newItemDescription = ""
    @State var newItemContent = ""

    var body: some View  {
        NavigationStack(path: $navigation.path) {
            List {
                ForEach(filteredItems) { item in
                    NavigationLink(value: item.id) {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.contentDescription)
                                .font(.subheadline)
                                .contextMenu {
                                    Button("Delete") {
                                        if let index = filteredItems.firstIndex(where: { $0.id == item.id }) {
                                            deleteItems(offsets: IndexSet(integer: index))
                                        }
                                    }
                                }
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .searchable(text: $navigation.searchText, prompt: "Search saved content")
            .navigationDestination(for: UUID.self) { id in
                if let item = items.first(where: { $0.id == id }) {
                    ScrollView {
                        Text(item.content)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                    }
                    .navigationTitle(item.name)
                    .appEntityIdentifier(EntityIdentifier(for: DataEntity.self, identifier: item.id))
                } else {
                    ContentUnavailableView("Content Not Found", systemImage: "doc.questionmark")
                }
            }
        }
            .toolbar {
                Button {
                    showAddSheet.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showAddSheet) {
                Form {
                    TextField("Name", text: $newItemName)
                    TextField("Description", text: $newItemDescription)
                    TextField("Content", text: $newItemContent)
                    HStack {
                        Spacer()
                        Button("Cancel") {
                            newItemName = ""
                            newItemDescription = ""
                            newItemContent = ""
                            showAddSheet = false
                        }
                        .buttonStyle(.bordered)
                        Button {
                            addItem(name: newItemName, desc: newItemDescription, content: newItemContent)
                            showAddSheet = false
                        } label: {
                            Text("Add Item")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding()
            }
            .alert("Could Not Complete Action", isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "")
            }
            .task {
                do {
                    try await DataIndexer.indexAll()
                } catch {
                    errorMessage = "Saved items could not be refreshed in Spotlight: \(error.localizedDescription)"
                }
            }
    }

    private var filteredItems: [DataModel] {
        let term = navigation.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !term.isEmpty else { return items }
        return items.filter {
            $0.name.localizedStandardContains(term) ||
            $0.contentDescription.localizedStandardContains(term) ||
            $0.content.localizedStandardContains(term)
        }
    }

    private func addItem(name: String, desc: String, content: String) {
        withAnimation {
            let newItem = DataModel(name: name, contentDescription: desc, content: content)
            modelContext.insert(newItem)
            do {
                try modelContext.save()
            } catch {
                modelContext.delete(newItem)
                errorMessage = "The item could not be saved: \(error.localizedDescription)"
                return
            }
            Task {
                do {
                    try await DataIndexer.index(newItem)
                } catch {
                    errorMessage = "The item was saved but could not be indexed for Siri and Spotlight: \(error.localizedDescription)"
                }
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        let selectedItems = offsets.map { filteredItems[$0] }
        Task {
            for item in selectedItems {
                do {
                    try await DataIndexer.remove(item.id)
                    withAnimation { modelContext.delete(item) }
                    try modelContext.save()
                } catch {
                    errorMessage = "The item could not be deleted: \(error.localizedDescription)"
                }
            }
        }
    }
}
