import Foundation
import UIKit

enum ExternalPlatform: String, CaseIterable, Identifiable, Sendable {
    case douyin
    case xiaohongshu
    case meituan
    case hktvMall

    var id: String { rawValue }
    var title: String {
        switch self {
        case .douyin: "抖音"
        case .xiaohongshu: "小红书"
        case .meituan: "美团"
        case .hktvMall: "HKTVmall"
        }
    }
    var systemImage: String {
        switch self {
        case .douyin: "play.rectangle.fill"
        case .xiaohongshu: "heart.rectangle.fill"
        case .meituan: "takeoutbag.and.cup.and.straw.fill"
        case .hktvMall: "cart.fill"
        }
    }
}

struct ExternalLink: Equatable, Sendable {
    let platform: ExternalPlatform
    let keyword: String
    let appURL: URL?
    let webURL: URL
    let copiesKeyword: Bool
}

enum ExternalLinkBuilder {
    enum LinkError: Error { case emptyKeyword, invalidURL }

    static func tutorial(platform: ExternalPlatform, recipeName: String) throws -> ExternalLink {
        try build(platform: platform, keyword: "\(recipeName) 家常做法")
    }

    static func shopping(platform: ExternalPlatform, ingredients: [String]) throws -> ExternalLink {
        try build(platform: platform, keyword: ingredients.joined(separator: " "))
    }

    static func build(platform: ExternalPlatform, keyword rawKeyword: String) throws -> ExternalLink {
        let keyword = rawKeyword.split(whereSeparator: \.isWhitespace).joined(separator: " ")
        guard !keyword.isEmpty else { throw LinkError.emptyKeyword }

        switch platform {
        case .douyin:
            return ExternalLink(
                platform: platform,
                keyword: keyword,
                appURL: try url(scheme: "snssdk1128", host: "search", query: ["keyword": keyword]),
                webURL: try pathURL(base: "https://www.douyin.com/search", component: keyword),
                copiesKeyword: false
            )
        case .xiaohongshu:
            return ExternalLink(
                platform: platform,
                keyword: keyword,
                appURL: try url(scheme: "xhsdiscover", host: "search", path: "/result", query: ["keyword": keyword]),
                webURL: try url(scheme: "https", host: "www.xiaohongshu.com", path: "/search_result", query: ["keyword": keyword]),
                copiesKeyword: false
            )
        case .meituan:
            return ExternalLink(
                platform: platform,
                keyword: keyword,
                appURL: try url(scheme: "imeituan", host: "www.meituan.com", path: "/search", query: ["q": keyword]),
                webURL: try constantURL("https://www.meituan.com/"),
                copiesKeyword: true
            )
        case .hktvMall:
            return ExternalLink(
                platform: platform,
                keyword: keyword,
                appURL: nil,
                webURL: try url(scheme: "https", host: "www.hktvmall.com", path: "/hktv/zh/search_a", query: ["keyword": keyword]),
                copiesKeyword: false
            )
        }
    }

    private static func url(scheme: String, host: String, path: String = "", query: [String: String]) throws -> URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = query.sorted(by: { $0.key < $1.key }).map { URLQueryItem(name: $0.key, value: $0.value) }
        guard let url = components.url else { throw LinkError.invalidURL }
        return url
    }

    private static func pathURL(base: String, component: String) throws -> URL {
        guard let baseURL = URL(string: base) else { throw LinkError.invalidURL }
        return baseURL.appending(path: component)
    }

    private static func constantURL(_ value: String) throws -> URL {
        guard let url = URL(string: value) else { throw LinkError.invalidURL }
        return url
    }
}

@MainActor
enum ExternalLinkOpener {
    static func open(_ link: ExternalLink) async {
        if link.copiesKeyword { UIPasteboard.general.string = link.keyword }
        if let appURL = link.appURL, await UIApplication.shared.open(appURL) { return }
        _ = await UIApplication.shared.open(link.webURL)
    }
}

struct PhotoRecognitionDraft: Sendable {
    let localImageIdentifier: String
}

protocol IngredientRecognitionService: Sendable {
    func recognize(_ draft: PhotoRecognitionDraft) async throws -> IngredientDefinition?
}
