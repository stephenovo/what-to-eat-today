import Foundation

enum RecommendationEngine {
    static func recommendations(
        pantry: [PantryItem],
        recipes: [Recipe] = RecipeCatalog.recipes
    ) -> [RecipeRecommendation] {
        let availableIDs = Set(pantry.compactMap(\.ingredientID))
        let expiringIDs = Set(pantry.filter { $0.isExpiringSoon }.compactMap(\.ingredientID))

        return recipes.map { recipe in
            let matched = recipe.ingredients.filter { availableIDs.contains($0.ingredientID) }
            let missing = recipe.ingredients.filter { !availableIDs.contains($0.ingredientID) }
            let expiringNames = recipe.ingredients
                .filter { expiringIDs.contains($0.ingredientID) }
                .map(\.name)
            let ratio = Double(matched.count) / Double(max(recipe.ingredients.count, 1))
            let score = Int((ratio * 100).rounded()) + (missing.isEmpty ? 30 : 0) - missing.count * 8 + expiringNames.count * 12
            return RecipeRecommendation(recipe: recipe, matched: matched, missing: missing, score: score, expiringNames: expiringNames)
        }
        .sorted {
            if $0.score != $1.score { return $0.score > $1.score }
            if $0.missing.count != $1.missing.count { return $0.missing.count < $1.missing.count }
            return $0.recipe.minutes < $1.recipe.minutes
        }
    }
}
