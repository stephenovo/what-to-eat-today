import SwiftUI

struct RecipeDetailView: View {
    @Environment(PantryStore.self) private var pantry
    let recipe: Recipe

    private var recommendation: RecipeRecommendation {
        RecommendationEngine.recommendations(pantry: pantry.items, recipes: [recipe])[0]
    }

    var body: some View {
        LuluPage {
            VStack(alignment: .leading, spacing: 20) {
                hero
                    .padding(.top, 8)
                ingredients
                if !recommendation.missing.isEmpty { shopping }
                steps
                tutorial
                tip
            }
        }
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var hero: some View {
        VStack(spacing: 14) {
            Text(recipe.emoji)
                .font(.system(size: 86))
            Text(recipe.name)
                .font(.system(size: 30, weight: .heavy, design: .rounded))
                .foregroundStyle(LuluPalette.ink)
            Text(recipe.subtitle)
                .font(.system(size: 14))
                .foregroundStyle(LuluPalette.sage)
            HStack(spacing: 10) {
                MatchPill(recommendation: recommendation)
                detailPill("\(recipe.minutes) 分钟", icon: "clock.fill")
                detailPill(recipe.difficulty, icon: "flame.fill")
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 22)
        .background(
            LinearGradient(colors: [LuluPalette.yellowSoft, LuluPalette.paper], startPoint: .top, endPoint: .bottom),
            in: RoundedRectangle(cornerRadius: 26, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(LuluPalette.yellow.opacity(0.55), lineWidth: 1)
        }
    }

    private var ingredients: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeading(title: "主要食材", subtitle: "按 2 人份")
            requirementCard(recipe.primaryIngredients)
            if !recipe.seasonings.isEmpty {
                SectionHeading(title: "所需佐料", subtitle: "也会参与推荐和缺料计算")
                    .padding(.top, 4)
                requirementCard(recipe.seasonings)
            }
        }
    }

    private func requirementCard(_ requirements: [RecipeIngredient]) -> some View {
        VStack(spacing: 0) {
            ForEach(Array(requirements.enumerated()), id: \.element) { index, ingredient in
                HStack(spacing: 12) {
                    Text(ingredient.emoji).font(.system(size: 26))
                    Text(ingredient.name)
                        .font(.system(size: 14, weight: .semibold))
                    Spacer()
                    Text(ingredient.amount)
                        .font(.system(size: 12))
                        .foregroundStyle(LuluPalette.sage)
                    let hasIngredient = !recommendation.missing.contains(ingredient)
                    Image(systemName: hasIngredient ? "checkmark.circle.fill" : "plus.circle")
                        .foregroundStyle(hasIngredient ? LuluPalette.green : LuluPalette.red)
                        .accessibilityLabel(hasIngredient ? "冰箱里有" : "需要购买")
                }
                .padding(.vertical, 11)
                if index < requirements.count - 1 { Divider().foregroundStyle(LuluPalette.line) }
            }
        }
        .luluCard()
    }

    private var shopping: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeading(title: "补齐缺料", subtitle: recommendation.missing.map(\.name).joined(separator: "、"))
            HStack(spacing: 10) {
                platformButton(.meituan, kind: .shopping)
                platformButton(.hktvMall, kind: .shopping)
            }
        }
    }

    private var steps: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeading(title: "开始做吧")
            VStack(spacing: 16) {
                ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 13) {
                        Text("\(index + 1)")
                            .font(.system(size: 13, weight: .heavy))
                            .foregroundStyle(LuluPalette.ink)
                            .frame(width: 30, height: 30)
                            .background(LuluPalette.yellow, in: Circle())
                        Text(step)
                            .font(.system(size: 14))
                            .foregroundStyle(LuluPalette.ink)
                            .lineSpacing(4)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .luluCard()
        }
    }

    private var tutorial: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeading(title: "找个视频跟着学")
            HStack(spacing: 10) {
                platformButton(.douyin, kind: .tutorial)
                platformButton(.xiaohongshu, kind: .tutorial)
            }
        }
    }

    private var tip: some View {
        HStack(alignment: .top, spacing: 12) {
            LuluBrandMark(compact: true)
            VStack(alignment: .leading, spacing: 4) {
                Text("噜噜的小提示")
                    .font(.system(size: 13, weight: .bold))
                Text(recipe.tip)
                    .font(.system(size: 13))
                    .foregroundStyle(LuluPalette.sage)
                    .lineSpacing(3)
            }
        }
        .luluCard()
    }

    private func detailPill(_ title: String, icon: String) -> some View {
        Label(title, systemImage: icon)
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(LuluPalette.ink)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(LuluPalette.canvas, in: Capsule())
    }

    private func platformButton(_ platform: ExternalPlatform, kind: LinkKind) -> some View {
        Button {
            Task {
                let link: ExternalLink?
                switch kind {
                case .tutorial:
                    link = try? ExternalLinkBuilder.tutorial(platform: platform, recipeName: recipe.name)
                case .shopping:
                    link = try? ExternalLinkBuilder.shopping(platform: platform, ingredients: recommendation.missing.map(\.name))
                }
                if let link { await ExternalLinkOpener.open(link) }
            }
        } label: {
            Label(platform.title, systemImage: platform.systemImage)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(LuluPalette.ink)
                .frame(maxWidth: .infinity)
                .frame(height: 46)
                .background(LuluPalette.paper, in: RoundedRectangle(cornerRadius: 14))
                .overlay { RoundedRectangle(cornerRadius: 14).stroke(LuluPalette.line, lineWidth: 1) }
        }
        .buttonStyle(.plain)
    }
}

private enum LinkKind { case tutorial, shopping }
