import Foundation
import Observation

@MainActor
@Observable
final class PantryStore {
    private(set) var items: [PantryItem] = []
    private let defaults: UserDefaults
    private let storageKey = "what-to-eat-today.pantry.v1"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        load()
        #if DEBUG
        if items.isEmpty, ProcessInfo.processInfo.arguments.contains("-DemoPantry") {
            seedVisualDemo()
        }
        #endif
    }

    func add(
        name rawName: String,
        category: IngredientCategory? = nil,
        quantity: Double,
        unit: String,
        expiryDate: Date?
    ) {
        let name = rawName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty, quantity > 0 else { return }
        let catalogItem = IngredientCatalog.find(matching: name)
        items.append(
            PantryItem(
                id: UUID(),
                ingredientID: catalogItem?.id,
                name: catalogItem?.name ?? name,
                emoji: catalogItem?.emoji ?? "🥣",
                category: catalogItem?.category ?? category,
                quantity: quantity,
                unit: unit.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "份" : unit,
                addedAt: .now,
                expiryDate: expiryDate
            )
        )
        sortAndSave()
    }

    func increment(_ item: PantryItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index].quantity += 1
        save()
    }

    func decrement(_ item: PantryItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        if items[index].quantity <= 1 {
            items.remove(at: index)
        } else {
            items[index].quantity -= 1
        }
        save()
    }

    func remove(_ item: PantryItem) {
        items.removeAll { $0.id == item.id }
        save()
    }

    func remove(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func removeAll() {
        items.removeAll()
        save()
    }

    private func sortAndSave() {
        items.sort { lhs, rhs in
            switch (lhs.expiryDate, rhs.expiryDate) {
            case let (.some(a), .some(b)): a < b
            case (.some, .none): true
            case (.none, .some): false
            case (.none, .none): lhs.addedAt > rhs.addedAt
            }
        }
        save()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        defaults.set(data, forKey: storageKey)
    }

    private func load() {
        guard let data = defaults.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([PantryItem].self, from: data) else { return }
        items = decoded
    }

    #if DEBUG
    private func seedVisualDemo() {
        let soon = Calendar.current.date(byAdding: .day, value: 1, to: .now)
        add(name: "番茄", quantity: 2, unit: "个", expiryDate: soon)
        add(name: "鸡蛋", quantity: 6, unit: "个", expiryDate: nil)
        add(name: "面条", quantity: 300, unit: "克", expiryDate: nil)
        add(name: "黄瓜", quantity: 1, unit: "根", expiryDate: nil)
        add(name: "食用油", quantity: 500, unit: "毫升", expiryDate: nil)
        add(name: "食盐", quantity: 1, unit: "袋", expiryDate: nil)
        add(name: "白糖", quantity: 1, unit: "袋", expiryDate: nil)
    }
    #endif
}
