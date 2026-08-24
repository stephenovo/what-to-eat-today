import XCTest
@testable import WhatToEatToday

final class ExternalLinkTests: XCTestCase {
    func testDouyinTutorialEncodesChineseKeyword() throws {
        let link = try ExternalLinkBuilder.tutorial(platform: .douyin, recipeName: "番茄炒蛋")

        XCTAssertEqual(link.keyword, "番茄炒蛋 家常做法")
        XCTAssertEqual(link.appURL?.scheme, "snssdk1128")
        XCTAssertTrue(link.webURL.absoluteString.contains("%E7%95%AA%E8%8C%84"))
    }

    func testHKTVMallUsesSearchQuery() throws {
        let link = try ExternalLinkBuilder.shopping(platform: .hktvMall, ingredients: ["西兰花", "虾仁"])
        let components = URLComponents(url: link.webURL, resolvingAgainstBaseURL: false)

        XCTAssertEqual(components?.host, "www.hktvmall.com")
        XCTAssertEqual(components?.queryItems?.first(where: { $0.name == "keyword" })?.value, "西兰花 虾仁")
    }

    func testEmptyKeywordIsRejected() {
        XCTAssertThrowsError(try ExternalLinkBuilder.build(platform: .meituan, keyword: "  \n "))
    }
}
