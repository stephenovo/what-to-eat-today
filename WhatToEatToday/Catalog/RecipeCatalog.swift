import Foundation

enum RecipeCatalog {
    static let recipes: [Recipe] = [
        recipe(
            "tomato-egg", "番茄炒蛋", "酸甜下饭，十分钟家常菜", "🍅",
            12, "简单",
            [i("tomato", "番茄", "2 个", "🍅"), i("egg", "鸡蛋", "3 个", "🥚")],
            ["番茄切块，鸡蛋加少许盐打散。", "热锅放油，鸡蛋炒至刚凝固后盛出。", "番茄炒出汁，倒回鸡蛋翻匀，按口味调味。"],
            "番茄炒软一点，自然的酸甜味会更浓。"
        ),
        recipe(
            "egg-noodles", "番茄鸡蛋面", "一碗热乎乎的安心晚饭", "🍜",
            18, "简单",
            [i("tomato", "番茄", "1 个", "🍅"), i("egg", "鸡蛋", "1 个", "🥚"), i("noodles", "面条", "1 份", "🍜")],
            ["番茄切块，鸡蛋打散。", "炒香番茄并加入一碗水煮开。", "下面条煮熟，淋入蛋液，调味后出锅。"],
            "蛋液绕圈淋入沸腾汤里，会形成更漂亮的蛋花。"
        ),
        recipe(
            "potato-beef", "土豆炖牛肉", "软烂浓香，适合周末慢慢吃", "🥘",
            55, "中等",
            [i("potato", "土豆", "2 个", "🥔"), i("beef", "牛肉", "500 克", "🥩"), i("carrot", "胡萝卜", "1 根", "🥕")],
            ["牛肉冷水下锅焯去浮沫。", "炒香牛肉，加热水小火炖 35 分钟。", "加入土豆和胡萝卜，再炖 15 分钟至软烂。"],
            "一定加热水，牛肉的口感会更松软。"
        ),
        recipe(
            "broccoli-shrimp", "西兰花炒虾仁", "清爽鲜甜的轻负担组合", "🦐",
            16, "简单",
            [i("broccoli", "西兰花", "1 棵", "🥦"), i("shrimp", "虾仁", "250 克", "🦐"), i("garlic", "大蒜", "2 瓣", "🧄", true)],
            ["西兰花切小朵焯水一分钟。", "虾仁擦干，热锅炒至变色。", "加入蒜末和西兰花，大火翻炒调味。"],
            "西兰花先焯后炒，颜色会保持翠绿。"
        ),
        recipe(
            "tofu-mushroom", "香菇烧豆腐", "酱香柔软，素菜也很满足", "🍄",
            22, "简单",
            [i("tofu", "豆腐", "1 盒", "◻️"), i("mushroom", "香菇", "150 克", "🍄"), i("green_pepper", "青椒", "1 个", "🫑")],
            ["豆腐切块煎至两面金黄。", "香菇切片炒香，加少量水和调味汁。", "放回豆腐焖五分钟，加入青椒收汁。"],
            "豆腐先用厨房纸吸干水分，煎的时候更完整。"
        ),
        recipe(
            "cucumber-egg", "黄瓜炒鸡蛋", "脆嫩清香的快手菜", "🥒",
            10, "简单",
            [i("cucumber", "黄瓜", "1 根", "🥒"), i("egg", "鸡蛋", "2 个", "🥚")],
            ["黄瓜切片，鸡蛋打散。", "鸡蛋炒至蓬松后盛出。", "黄瓜大火翻炒一分钟，倒回鸡蛋调味。"],
            "黄瓜不要久炒，保留一点脆感最好吃。"
        ),
        recipe(
            "chicken-pepper", "青椒鸡丁", "鲜香微辣，配米饭正好", "🍗",
            24, "中等",
            [i("chicken", "鸡胸肉", "300 克", "🍗"), i("green_pepper", "青椒", "2 个", "🫑"), i("rice", "大米", "2 人份", "🍚")],
            ["鸡胸肉切丁，加盐和淀粉抓匀。", "鸡丁滑炒至变色，盛出备用。", "青椒炒出香气，倒回鸡丁调味翻匀。"],
            "鸡丁裹薄薄一层淀粉，口感不容易柴。"
        ),
        recipe(
            "salmon-broccoli", "香煎三文鱼配西兰花", "一盘完成的清爽正餐", "🐟",
            25, "中等",
            [i("salmon", "三文鱼", "2 块", "🐟"), i("broccoli", "西兰花", "1 棵", "🥦"), i("lemon", "柠檬", "半个", "🍋")],
            ["三文鱼擦干，两面撒盐静置。", "皮朝下煎至酥脆，翻面煎熟。", "西兰花焯熟装盘，挤上柠檬汁。"],
            "下锅前把鱼表面擦干，才更容易煎出脆皮。"
        ),
        recipe(
            "egg-fried-rice", "家常蛋炒饭", "把剩米饭变成香喷喷的一餐", "🍳",
            12, "简单",
            [i("rice", "大米", "2 碗熟饭", "🍚"), i("egg", "鸡蛋", "2 个", "🥚"), i("carrot", "胡萝卜", "半根", "🥕")],
            ["米饭打散，胡萝卜切小丁。", "鸡蛋炒散，加入胡萝卜翻炒。", "倒入米饭大火炒散，调味后出锅。"],
            "冷藏过的米饭水分更少，炒出来粒粒分明。"
        ),
        recipe(
            "garlic-lettuce", "蒜蓉生菜", "五分钟也能有一盘绿叶菜", "🥬",
            7, "简单",
            [i("lettuce", "生菜", "1 棵", "🥬"), i("garlic", "大蒜", "3 瓣", "🧄")],
            ["生菜洗净沥干，大蒜切末。", "热油炒香一半蒜末，下生菜大火翻炒。", "生菜刚软时调味，撒剩余蒜末出锅。"],
            "全程大火快炒，生菜才不会出太多水。"
        ),
        recipe(
            "corn-carrot-soup", "玉米胡萝卜汤", "清甜温润的一锅汤", "🌽",
            40, "简单",
            [i("corn", "玉米", "1 根", "🌽"), i("carrot", "胡萝卜", "1 根", "🥕"), i("pork", "猪肉", "250 克", "🥩")],
            ["玉米和胡萝卜切块，猪肉焯水。", "所有食材放入锅中，加足量清水。", "煮开后转小火 30 分钟，最后加盐。"],
            "最后再加盐，汤会更清甜。"
        ),
        recipe(
            "banana-toast", "香蕉芝士吐司", "不费脑筋的香甜早餐", "🍌",
            10, "简单",
            [i("banana", "香蕉", "1 根", "🍌"), i("bread", "面包", "2 片", "🍞"), i("cheese", "芝士", "1 片", "🧀")],
            ["香蕉切片铺在吐司上。", "盖上芝士片和另一片吐司。", "平底锅小火煎至两面金黄、芝士融化。"],
            "用熟一点的香蕉，甜味更足。"
        )
    ]

    private static func i(_ id: String, _ name: String, _ amount: String, _ emoji: String, _ staple: Bool = false) -> RecipeIngredient {
        RecipeIngredient(ingredientID: id, name: name, amount: amount, emoji: emoji, isPantryStaple: staple)
    }

    private static func recipe(
        _ id: String, _ name: String, _ subtitle: String, _ emoji: String,
        _ minutes: Int, _ difficulty: String, _ ingredients: [RecipeIngredient],
        _ steps: [String], _ tip: String
    ) -> Recipe {
        Recipe(id: id, name: name, subtitle: subtitle, emoji: emoji, minutes: minutes, difficulty: difficulty, ingredients: ingredients, steps: steps, tip: tip)
    }
}
