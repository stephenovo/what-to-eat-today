import XCTest
@testable import WhatToEatToday

final class RecommendationEngineTests: XCTestCase {
    func testReadyRecipeRanksAheadOfMissingRecipe() {
        let pantry = [
            PantryItem(id: UUID(), ingredientID: "tomato", name: "番茄", emoji: "🍅", quantity: 2, unit: "个", addedAt: .now, expiryDate: nil),
            PantryItem(id: UUID(), ingredientID: "egg", name: "鸡蛋", emoji: "🥚", quantity: 3, unit: "个", addedAt: .now, expiryDate: nil),
            PantryItem(id: UUID(), ingredientID: "cooking_oil", name: "食用油", emoji: "🫗", quantity: 500, unit: "毫升", addedAt: .now, expiryDate: nil),
            PantryItem(id: UUID(), ingredientID: "salt", name: "食盐", emoji: "🧂", quantity: 1, unit: "袋", addedAt: .now, expiryDate: nil),
            PantryItem(id: UUID(), ingredientID: "sugar", name: "白糖", emoji: "🍚", quantity: 1, unit: "袋", addedAt: .now, expiryDate: nil)
        ]

        let results = RecommendationEngine.recommendations(pantry: pantry)

        XCTAssertEqual(results.first?.recipe.id, "tomato-egg")
        XCTAssertTrue(results.first?.isReady == true)
    }

    func testMissingSeasoningsAreIncludedInRecommendation() {
        let recipe = RecipeCatalog.recipes.first { $0.id == "broccoli-shrimp" }!
        let pantry = [
            PantryItem(id: UUID(), ingredientID: "broccoli", name: "西兰花", emoji: "🥦", quantity: 1, unit: "棵", addedAt: .now, expiryDate: nil),
            PantryItem(id: UUID(), ingredientID: "shrimp", name: "虾仁", emoji: "🦐", quantity: 250, unit: "克", addedAt: .now, expiryDate: nil)
        ]

        let result = RecommendationEngine.recommendations(pantry: pantry, recipes: [recipe])[0]

        XCTAssertFalse(result.isReady)
        XCTAssertTrue(result.missing.contains { $0.ingredientID == "garlic" })
        XCTAssertTrue(result.missing.contains { $0.ingredientID == "cooking_oil" })
        XCTAssertTrue(result.missing.contains { $0.ingredientID == "salt" })
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

    func testExpandedCatalogHasUniqueRecipeAndIngredientIDs() {
        let recipeIDs = RecipeCatalog.recipes.map(\.id)
        let ingredientIDs = IngredientCatalog.items.map(\.id)

        XCTAssertEqual(RecipeCatalog.recipes.count, 36)
        XCTAssertEqual(IngredientCatalog.items.count, 62)
        XCTAssertEqual(Set(recipeIDs).count, recipeIDs.count)
        XCTAssertEqual(Set(ingredientIDs).count, ingredientIDs.count)
    }

    func testEveryRecipeIngredientExistsInIngredientCatalog() {
        let knownIngredientIDs = Set(IngredientCatalog.items.map(\.id))
        let unknownReferences = RecipeCatalog.recipes.flatMap { recipe in
            recipe.ingredients
                .filter { !knownIngredientIDs.contains($0.ingredientID) }
                .map { "\(recipe.id):\($0.ingredientID)" }
        }

        XCTAssertTrue(unknownReferences.isEmpty, "Unknown ingredient references: \(unknownReferences)")
    }

    func testEveryRecipeHasReadableContent() {
        for recipe in RecipeCatalog.recipes {
            XCTAssertFalse(recipe.name.isEmpty)
            XCTAssertFalse(recipe.ingredients.isEmpty, "\(recipe.id) has no ingredients")
            XCTAssertFalse(recipe.steps.isEmpty, "\(recipe.id) has no steps")
            XCTAssertFalse(recipe.tip.isEmpty, "\(recipe.id) has no tip")
        }
    }

    func testRecipeSeparatesPrimaryIngredientsAndSeasonings() {
        let recipe = RecipeCatalog.recipes.first { $0.id == "tomato-egg" }!

        XCTAssertEqual(recipe.primaryIngredients.map(\.ingredientID), ["tomato", "egg"])
        XCTAssertEqual(Set(recipe.seasonings.map(\.ingredientID)), ["cooking_oil", "salt", "sugar"])
    }

    @MainActor
    func testCustomSeasoningCategorySurvivesPersistence() throws {
        let suiteName = "RecommendationEngineTests.\(UUID().uuidString)"
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suiteName))
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let store = PantryStore(defaults: defaults)
        store.add(name: "自制辣椒油", category: .seasoning, quantity: 1, unit: "瓶", expiryDate: nil)
        let reloadedStore = PantryStore(defaults: defaults)

        XCTAssertEqual(reloadedStore.items.first?.category, .seasoning)
    }
}
