import SwiftUI

enum LuluPalette {
    static let canvas = Color(red: 246 / 255, green: 244 / 255, blue: 236 / 255)
    static let paper = Color(red: 255 / 255, green: 253 / 255, blue: 248 / 255)
    static let ink = Color(red: 31 / 255, green: 45 / 255, blue: 37 / 255)
    static let sage = Color(red: 93 / 255, green: 107 / 255, blue: 99 / 255)
    static let line = Color(red: 220 / 255, green: 227 / 255, blue: 217 / 255)
    static let yellow = Color(red: 246 / 255, green: 201 / 255, blue: 69 / 255)
    static let yellowSoft = yellow.opacity(0.22)
    static let green = Color(red: 77 / 255, green: 154 / 255, blue: 104 / 255)
    static let red = Color(red: 201 / 255, green: 86 / 255, blue: 66 / 255)
}

enum LuluLayout {
    static let gutter: CGFloat = 20
    static let radius: CGFloat = 18
}

struct LuluPage<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        ScrollView {
            content
                .padding(.horizontal, LuluLayout.gutter)
                .padding(.bottom, 28)
        }
        .background(LuluPalette.canvas.ignoresSafeArea())
    }
}

struct LuluCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(LuluPalette.paper, in: RoundedRectangle(cornerRadius: LuluLayout.radius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: LuluLayout.radius, style: .continuous)
                    .stroke(LuluPalette.line, lineWidth: 1)
            }
    }
}

extension View {
    func luluCard() -> some View { modifier(LuluCardModifier()) }
}

struct LuluBrandMark: View {
    var compact = false

    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle().fill(LuluPalette.yellow)
                Circle()
                    .fill(LuluPalette.ink)
                    .frame(width: compact ? 4 : 5, height: compact ? 4 : 5)
                    .offset(x: compact ? -5 : -6, y: -2)
                Circle()
                    .fill(LuluPalette.ink)
                    .frame(width: compact ? 4 : 5, height: compact ? 4 : 5)
                    .offset(x: compact ? 5 : 6, y: -2)
                Capsule()
                    .fill(LuluPalette.ink)
                    .frame(width: compact ? 10 : 13, height: 3)
                    .offset(y: compact ? 6 : 8)
            }
            .frame(width: compact ? 30 : 38, height: compact ? 30 : 38)

            VStack(alignment: .leading, spacing: 0) {
                Text("今天吃这个")
                    .font(.system(size: compact ? 15 : 18, weight: .bold, design: .rounded))
                    .foregroundStyle(LuluPalette.ink)
                if !compact {
                    Text("噜噜冰箱的纯软件新搭档")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(LuluPalette.sage)
                }
            }
        }
        .accessibilityElement(children: .combine)
    }
}

struct IngredientEmoji: View {
    let emoji: String
    var size: CGFloat = 48

    var body: some View {
        Text(emoji)
            .font(.system(size: size * 0.56))
            .frame(width: size, height: size)
            .background(LuluPalette.canvas, in: RoundedRectangle(cornerRadius: size * 0.28, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: size * 0.28, style: .continuous)
                    .stroke(LuluPalette.line, lineWidth: 1)
            }
    }
}

struct MatchPill: View {
    let recommendation: RecipeRecommendation

    var body: some View {
        Label(recommendation.statusTitle, systemImage: recommendation.isReady ? "checkmark.circle.fill" : "sparkles")
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(LuluPalette.ink)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background((recommendation.isReady ? LuluPalette.green : LuluPalette.yellow).opacity(0.18), in: Capsule())
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .bold))
            .foregroundStyle(LuluPalette.paper)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(LuluPalette.ink, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

struct SectionHeading: View {
    let title: String
    var subtitle: String? = nil

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(LuluPalette.ink)
            Spacer()
            if let subtitle {
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundStyle(LuluPalette.sage)
            }
        }
    }
}
