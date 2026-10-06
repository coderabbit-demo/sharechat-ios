import Foundation

public struct FeedAPI {
    public var baseURL = URL(string: "https://feed.sharechat.example")!
    public var session = URLSession.shared

    public init() {}

    public static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    public func getFeed(userId: String, lang: String?, cursor: String? = nil, limit: Int = 20) async throws -> FeedResponse {
        var components = URLComponents(url: baseURL.appendingPathComponent("v1/feed"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "user_id", value: userId),
            URLQueryItem(name: "limit", value: String(limit)),
        ]
        if let lang { components.queryItems?.append(URLQueryItem(name: "lang", value: lang)) }
        if let cursor { components.queryItems?.append(URLQueryItem(name: "cursor", value: cursor)) }

        let (data, _) = try await session.data(from: components.url!)
        return try Self.decoder.decode(FeedResponse.self, from: data)
    }
}
