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
        item("cabbage", "包菜", .vegetables, "🥬", ["卷心菜", "圆白菜"], "个"),
        item("chinese_cabbage", "大白菜", .vegetables, "🥬", ["白菜"], "棵"),
        item("zucchini", "西葫芦", .vegetables, "🥒", ["角瓜"], "根"),
        item("long_bean", "豆角", .vegetables, "🫛", ["四季豆", "豇豆"], "把"),
        item("lotus_root", "莲藕", .vegetables, "🪷", ["藕"], "节"),
        item("celery", "芹菜", .vegetables, "🥬", [], "把"),
        item("garlic_sprout", "蒜苗", .vegetables, "🌱", ["青蒜"], "把"),
        item("tofu", "豆腐", .protein, "◻️", [], "盒"),
        item("dried_tofu", "香干", .protein, "🟫", ["豆干"], "块"),
        item("chicken", "鸡胸肉", .protein, "🍗", ["鸡肉"], "克"),
        item("chicken_wing", "鸡翅", .protein, "🍗", ["鸡中翅", "翅中"], "个"),
        item("beef", "牛肉", .protein, "🥩", ["牛腩"], "克"),
        item("pork", "猪肉", .protein, "🥩", ["里脊"], "克"),
        item("pork_belly", "五花肉", .protein, "🥓", [], "克"),
        item("pork_rib", "排骨", .protein, "🍖", ["猪肋排"], "克"),
        item("peanut", "花生", .protein, "🥜", ["花生米"], "克"),
        item("shrimp", "虾仁", .seafood, "🦐", ["虾"], "克"),
        item("salmon", "三文鱼", .seafood, "🐟", ["鲑鱼"], "块"),
        item("bass", "鲈鱼", .seafood, "🐟", [], "条"),
        item("milk", "牛奶", .dairy, "🥛", ["鲜奶"], "盒"),
        item("cheese", "芝士", .dairy, "🧀", ["奶酪"], "片"),
        item("apple", "苹果", .fruit, "🍎", [], "个"),
        item("banana", "香蕉", .fruit, "🍌", [], "根"),
        item("lemon", "柠檬", .fruit, "🍋", [], "个"),
        item("rice", "大米", .staples, "🍚", ["米饭"], "克"),
        item("noodles", "面条", .staples, "🍜", ["挂面"], "克"),
        item("glass_noodles", "粉条", .staples, "🍜", ["红薯粉条", "粉丝"], "克"),
        item("bread", "面包", .staples, "🍞", ["吐司"], "片"),
        item("seaweed", "紫菜", .seafood, "🟪", ["干紫菜"], "克"),
        item("scallion", "大葱", .seasoning, "🌿", ["葱", "小葱", "香葱"], "根"),
        item("dried_chili", "干辣椒", .seasoning, "🌶️", ["辣椒", "小米辣"], "根"),
        item("doubanjiang", "豆瓣酱", .seasoning, "🫙", ["郫县豆瓣酱"], "勺"),
        item("sweet_bean_paste", "甜面酱", .seasoning, "🫙", ["黄豆酱", "炸酱"], "勺"),
        item("cooking_oil", "食用油", .seasoning, "🫗", ["油", "植物油", "花生油", "菜籽油"], "毫升"),
        item("salt", "食盐", .seasoning, "🧂", ["盐"], "克"),
        item("sugar", "白糖", .seasoning, "🍚", ["糖", "砂糖"], "克"),
        item("soy_sauce", "生抽", .seasoning, "🫙", ["酱油", "薄盐生抽"], "勺"),
        item("dark_soy_sauce", "老抽", .seasoning, "🫙", ["老抽酱油"], "勺"),
        item("vinegar", "香醋", .seasoning, "🫙", ["醋", "陈醋", "米醋"], "勺"),
        item("cooking_wine", "料酒", .seasoning, "🍶", ["绍兴酒", "花雕酒"], "勺"),
        item("sesame_oil", "香油", .seasoning, "🫗", ["芝麻油"], "勺"),
        item("oyster_sauce", "蚝油", .seasoning, "🫙", [], "勺"),
        item("starch", "淀粉", .seasoning, "🥣", ["生粉", "玉米淀粉"], "克"),
        item("black_pepper", "黑胡椒", .seasoning, "⚫️", ["胡椒粉", "白胡椒"], "克"),
        item("sichuan_pepper", "花椒", .seasoning, "🔴", ["花椒粉"], "克"),
        item("cola", "可乐", .beverage, "🥤", [], "罐"),
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

    static func definition(for id: String?) -> IngredientDefinition? {
        guard let id else { return nil }
        return items.first { $0.id == id }
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
