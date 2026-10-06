import Foundation

// Mirrors GET /v1/feed from sharechat-feed-service (api/openapi.yaml).

public struct FeedResponse: Decodable {
    public let items: [FeedItem]
    public let nextCursor: String?

    enum CodingKeys: String, CodingKey {
        case items
        case nextCursor = "next_cursor"
    }
}

public struct FeedItem: Decodable, Identifiable {
    public let postId: String
    public let author: Author
    public let media: Media
    public let caption: String?
    public let language: String
    public var likeCount: Int
    public let createdAt: Date

    public var id: String { postId }

    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case author
        case media
        case caption
        case language
        case likeCount = "like_count"
        case createdAt = "created_at"
    }
}

public struct Author: Decodable {
    public let id: String
    public let handle: String
    public let avatarUrl: URL?

    enum CodingKeys: String, CodingKey {
        case id
        case handle
        case avatarUrl = "avatar_url"
    }
}

public struct Media: Decodable {
    public let type: String
    public let url: URL
    public let durationMs: Int?

    enum CodingKeys: String, CodingKey {
        case type
        case url
        case durationMs = "duration_ms"
    }
}
