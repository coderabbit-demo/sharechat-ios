import Foundation
import Testing
@testable import FeedKit

struct FeedDecodingTests {

    private func fixture() throws -> Data {
        let url = try #require(Bundle.module.url(forResource: "feed_v1", withExtension: "json", subdirectory: "Fixtures"))
        return try Data(contentsOf: url)
    }

    @Test func decodesFeedResponse() throws {
        let feed = try FeedAPI.decoder.decode(FeedResponse.self, from: fixture())
        let item = try #require(feed.items.first)

        #expect(item.postId == "p_1001")
        #expect(item.author.handle == "priya_sings")
        #expect(item.likeCount == 1_240_000)
        #expect(feed.nextCursor == "1")
    }

    @Test func formatsCardFields() throws {
        let item = try #require(FeedAPI.decoder.decode(FeedResponse.self, from: fixture()).items.first)
        let now = try #require(ISO8601DateFormatter().date(from: "2026-10-06T08:00:00Z"))

        #expect(formatLikes(item.likeCount) == "12.4L")
        #expect(timeAgo(item.createdAt, now: now) == "13h")
    }
}
