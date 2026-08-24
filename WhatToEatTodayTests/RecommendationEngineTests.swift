import XCTest
@testable import WhatToEatToday

final class RecommendationEngineTests: XCTestCase {
    func testReadyRecipeRanksAheadOfMissingRecipe() {
        let pantry = [
            PantryItem(id: UUID(), ingredientID: "tomato", name: "番茄", emoji: "🍅", quantity: 2, unit: "个", addedAt: .now, expiryDate: nil),
            PantryItem(id: UUID(), ingredientID: "egg", name: "鸡蛋", emoji: "🥚", quantity: 3, unit: "个", addedAt: .now, expiryDate: nil)
        ]

        let results = RecommendationEngine.recommendations(pantry: pantry)

        XCTAssertEqual(results.first?.recipe.id, "tomato-egg")
        XCTAssertTrue(results.first?.isReady == true)
    }

    func testMissingIngredientsIgnorePantryStaples() {
        let recipe = RecipeCatalog.recipes.first { $0.id == "broccoli-shrimp" }!
        let pantry = [
            PantryItem(id: UUID(), ingredientID: "broccoli", name: "西兰花", emoji: "🥦", quantity: 1, unit: "棵", addedAt: .now, expiryDate: nil),
            PantryItem(id: UUID(), ingredientID: "shrimp", name: "虾仁", emoji: "🦐", quantity: 250, unit: "克", addedAt: .now, expiryDate: nil)
        ]

        let result = RecommendationEngine.recommendations(pantry: pantry, recipes: [recipe])[0]

        XCTAssertTrue(result.isReady)
        XCTAssertFalse(result.missing.contains { $0.ingredientID == "garlic" })
    }

    func testExpiringIngredientBoostsScore() {
        let soon = Calendar.current.date(byAdding: .day, value: 1, to: .now)
        let pantry = [
            PantryItem(id: UUID(), ingredientID: "cucumber", name: "黄瓜", emoji: "🥒", quantity: 1, unit: "根", addedAt: .now, expiryDate: soon)
        ]

        let results = RecommendationEngine.recommendations(pantry: pantry)
        let cucumberRecipe = results.first { $0.recipe.id == "cucumber-egg" }!

        XCTAssertEqual(cucumberRecipe.expiringNames, ["黄瓜"])
    }
}
