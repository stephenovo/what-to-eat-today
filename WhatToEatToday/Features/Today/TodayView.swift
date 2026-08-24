import SwiftUI

struct TodayView: View {
    @Environment(PantryStore.self) private var pantry
    @State private var showingAdd = false

    private var recommendations: [RecipeRecommendation] {
        RecommendationEngine.recommendations(pantry: pantry.items)
    }

    var body: some View {
        LuluPage {
            VStack(alignment: .leading, spacing: 20) {
                header
                    .padding(.top, 10)

                if pantry.items.isEmpty {
                    emptyPantry
                } else if let top = recommendations.first {
                    hero(top)
                    expiringStrip
                    recommendationsSection
                }
            }
        }
        .navigationDestination(for: Recipe.self) { recipe in
            RecipeDetailView(recipe: recipe)
        }
        .sheet(isPresented: $showingAdd) {
            AddIngredientSheet()
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        HStack {
            LuluBrandMark()
            Spacer()
            Text(Date.now.formatted(.dateTime.month().day().weekday(.wide)))
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(LuluPalette.sage)
        }
    }

    private var emptyPantry: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(LuluPalette.yellowSoft)
                    .frame(width: 132, height: 132)
                Text("🧺")
                    .font(.system(size: 70))
            }
            Text("先告诉噜噜家里有什么")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(LuluPalette.ink)
            Text("记录两三样食材就够了。推荐在手机上完成，不需要连接任何硬件。")
                .font(.system(size: 14))
                .foregroundStyle(LuluPalette.sage)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
            Button {
                showingAdd = true
            } label: {
                Label("添加第一样食材", systemImage: "plus")
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .padding(.top, 44)
        .luluCard()
    }

    private func hero(_ recommendation: RecipeRecommendation) -> some View {
        NavigationLink(value: recommendation.recipe) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("噜噜今天推荐")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(LuluPalette.sage)
                        Text(recommendation.recipe.name)
                            .font(.system(size: 30, weight: .heavy, design: .rounded))
                            .foregroundStyle(LuluPalette.ink)
                        Text(recommendation.recipe.subtitle)
                            .font(.system(size: 13))
                            .foregroundStyle(LuluPalette.sage)
                    }
                    Spacer(minLength: 10)
                    Text(recommendation.recipe.emoji)
                        .font(.system(size: 66))
                }

                HStack(spacing: 8) {
                    MatchPill(recommendation: recommendation)
                    Label("\(recommendation.recipe.minutes) 分钟", systemImage: "clock.fill")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(LuluPalette.ink)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(LuluPalette.canvas, in: Capsule())
                }

                if !recommendation.expiringNames.isEmpty {
                    Label("优先用掉：\(recommendation.expiringNames.joined(separator: "、"))", systemImage: "leaf.fill")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(LuluPalette.green)
                }

                HStack {
                    Text("看看怎么做")
                        .font(.system(size: 14, weight: .bold))
                    Spacer()
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 22))
                }
                .foregroundStyle(LuluPalette.ink)
            }
            .padding(20)
            .background(
                LinearGradient(
                    colors: [LuluPalette.yellow.opacity(0.44), LuluPalette.paper],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: RoundedRectangle(cornerRadius: 26, style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .stroke(LuluPalette.yellow.opacity(0.7), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var expiringStrip: some View {
        let expiring = pantry.items.filter { $0.isExpiringSoon }
        if !expiring.isEmpty {
            HStack(spacing: 12) {
                Image(systemName: "clock.badge.exclamationmark.fill")
                    .foregroundStyle(LuluPalette.red)
                    .font(.system(size: 22))
                VStack(alignment: .leading, spacing: 2) {
                    Text("先吃掉这些")
                        .font(.system(size: 14, weight: .bold))
                    Text(expiring.map(\.name).joined(separator: "、"))
                        .font(.system(size: 12))
                        .foregroundStyle(LuluPalette.sage)
                        .lineLimit(1)
                }
                Spacer()
            }
            .luluCard()
        }
    }

    private var recommendationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeading(title: "还可以做", subtitle: "按冰箱匹配")
            ForEach(recommendations.dropFirst().prefix(3)) { recommendation in
                RecipeCard(recommendation: recommendation)
            }
        }
    }
}
