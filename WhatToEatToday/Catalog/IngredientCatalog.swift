import Foundation

enum IngredientCatalog {
    static let items: [IngredientDefinition] = [
        item("tomato", "番茄", .vegetables, "🍅", ["西红柿"], "个"),
        item("egg", "鸡蛋", .protein, "🥚", ["蛋"], "个"),
        item("potato", "土豆", .vegetables, "🥔", ["马铃薯"], "个"),
        item("carrot", "胡萝卜", .vegetables, "🥕", ["红萝卜"], "根"),
        item("onion", "洋葱", .vegetables, "🧅", [], "个"),
        item("broccoli", "西兰花", .vegetables, "🥦", ["绿花椰菜"], "棵"),
        item("cucumber", "黄瓜", .vegetables, "🥒", ["青瓜"], "根"),
        item("lettuce", "生菜", .vegetables, "🥬", [], "棵"),
        item("bok_choy", "小白菜", .vegetables, "🥬", ["青菜", "上海青"], "把"),
        item("spinach", "菠菜", .vegetables, "🥬", [], "把"),
        item("mushroom", "香菇", .vegetables, "🍄", ["冬菇", "蘑菇"], "克"),
        item("corn", "玉米", .vegetables, "🌽", [], "根"),
        item("green_pepper", "青椒", .vegetables, "🫑", ["绿甜椒"], "个"),
        item("eggplant", "茄子", .vegetables, "🍆", [], "根"),
        item("tofu", "豆腐", .protein, "◻️", [], "盒"),
        item("chicken", "鸡胸肉", .protein, "🍗", ["鸡肉"], "克"),
        item("beef", "牛肉", .protein, "🥩", ["牛腩"], "克"),
        item("pork", "猪肉", .protein, "🥩", ["里脊"], "克"),
        item("shrimp", "虾仁", .seafood, "🦐", ["虾"], "克"),
        item("salmon", "三文鱼", .seafood, "🐟", ["鲑鱼"], "块"),
        item("milk", "牛奶", .dairy, "🥛", ["鲜奶"], "盒"),
        item("cheese", "芝士", .dairy, "🧀", ["奶酪"], "片"),
        item("apple", "苹果", .fruit, "🍎", [], "个"),
        item("banana", "香蕉", .fruit, "🍌", [], "根"),
        item("lemon", "柠檬", .fruit, "🍋", [], "个"),
        item("rice", "大米", .staples, "🍚", ["米饭"], "克"),
        item("noodles", "面条", .staples, "🍜", ["挂面"], "克"),
        item("bread", "面包", .staples, "🍞", ["吐司"], "片"),
        item("garlic", "大蒜", .seasoning, "🧄", ["蒜", "蒜头"], "瓣"),
        item("ginger", "生姜", .seasoning, "🫚", ["姜"], "块")
    ]

    static func find(matching rawName: String) -> IngredientDefinition? {
        let name = normalized(rawName)
        return items.first { item in
            ([item.name] + item.aliases).map(normalized).contains(name)
        }
    }

    static func filtered(by query: String, category: IngredientCategory?) -> [IngredientDefinition] {
        let term = normalized(query)
        return items.filter { item in
            let matchesCategory = category == nil || item.category == category
            let matchesQuery = term.isEmpty || ([item.name] + item.aliases).contains { normalized($0).contains(term) }
            return matchesCategory && matchesQuery
        }
    }

    private static func normalized(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased().replacingOccurrences(of: " ", with: "")
    }

    private static func item(
        _ id: String,
        _ name: String,
        _ category: IngredientCategory,
        _ emoji: String,
        _ aliases: [String],
        _ defaultUnit: String
    ) -> IngredientDefinition {
        IngredientDefinition(id: id, name: name, category: category, emoji: emoji, aliases: aliases, defaultUnit: defaultUnit)
    }
}
