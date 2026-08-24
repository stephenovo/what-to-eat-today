import SwiftUI

struct RecipeCard: View {
    let recommendation: RecipeRecommendation

    var body: some View {
        NavigationLink(value: recommendation.recipe) {
            HStack(spacing: 14) {
                Text(recommendation.recipe.emoji)
                    .font(.system(size: 38))
                    .frame(width: 68, height: 68)
                    .background(LuluPalette.yellowSoft, in: RoundedRectangle(cornerRadius: 18, style: .continuous))

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(recommendation.recipe.name)
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundStyle(LuluPalette.ink)
                        Spacer()
                        MatchPill(recommendation: recommendation)
                    }
                    Text(recommendation.recipe.subtitle)
                        .font(.system(size: 12))
                        .foregroundStyle(LuluPalette.sage)
                        .lineLimit(1)
                    HStack(spacing: 12) {
                        Label("\(recommendation.recipe.minutes) 分钟", systemImage: "clock")
                        Label("匹配 \(recommendation.matchPercent)%", systemImage: "chart.bar.fill")
                    }
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(LuluPalette.sage)
                }
            }
            .contentShape(Rectangle())
            .luluCard()
        }
        .buttonStyle(.plain)
    }
}
