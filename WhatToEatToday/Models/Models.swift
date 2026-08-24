import Foundation

struct IngredientDefinition: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let category: IngredientCategory
    let emoji: String
    let aliases: [String]
    let defaultUnit: String
}

enum IngredientCategory: String, CaseIterable, Codable, Sendable {
    case vegetables = "蔬菜"
    case protein = "肉蛋豆"
    case seafood = "水产"
    case dairy = "乳品"
    case fruit = "水果"
    case staples = "主食"
    case seasoning = "调味"
}

struct PantryItem: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    var ingredientID: String?
    var name: String
    var emoji: String
    var quantity: Double
    var unit: String
    var addedAt: Date
    var expiryDate: Date?

    var quantityText: String {
        let value = quantity.rounded() == quantity ? String(Int(quantity)) : String(format: "%.1f", quantity)
        return "\(value)\(unit)"
    }

    var expiryText: String? {
        guard let expiryDate else { return nil }
        let days = Calendar.current.dateComponents(
            [.day],
            from: Calendar.current.startOfDay(for: .now),
            to: Calendar.current.startOfDay(for: expiryDate)
        ).day ?? 0
        if days < 0 { return "已过期" }
        if days == 0 { return "今天到期" }
        if days <= 3 { return "还剩\(days)天" }
        return expiryDate.formatted(date: .abbreviated, time: .omitted)
    }

    var isExpiringSoon: Bool {
        guard let expiryDate else { return false }
        let interval = expiryDate.timeIntervalSince(Calendar.current.startOfDay(for: .now))
        return interval <= 3 * 24 * 60 * 60
    }
}

struct RecipeIngredient: Hashable, Sendable {
    let ingredientID: String
    let name: String
    let amount: String
    let emoji: String
    let isPantryStaple: Bool
}

struct Recipe: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let subtitle: String
    let emoji: String
    let minutes: Int
    let difficulty: String
    let ingredients: [RecipeIngredient]
    let steps: [String]
    let tip: String
}

struct RecipeRecommendation: Identifiable, Hashable, Sendable {
    let recipe: Recipe
    let matched: [RecipeIngredient]
    let missing: [RecipeIngredient]
    let score: Int
    let expiringNames: [String]

    var id: String { recipe.id }
    var isReady: Bool { missing.isEmpty }
    var matchPercent: Int {
        guard !recipe.ingredients.isEmpty else { return 100 }
        return Int((Double(matched.count) / Double(recipe.ingredients.count) * 100).rounded())
    }
    var statusTitle: String {
        if isReady { return "现在就能做" }
        if missing.count == 1 { return "只缺 1 样" }
        return "缺 \(missing.count) 样"
    }
}
