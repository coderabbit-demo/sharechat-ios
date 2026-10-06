# sharechat-ios

ShareChat iOS app: home feed (`FeedKit` package).

## Feed

The home feed calls `GET /v1/feed` on `sharechat-feed-service` with `URLSession` and `Codable`.
[`FeedItem.swift`](Sources/FeedKit/FeedItem.swift) mirrors the service's `api/openapi.yaml`:
snake_case `CodingKeys`, and `created_at` decoded as ISO-8601. A missing or mistyped key fails decoding
of the whole response.

Each card shows the author, media, caption, time since posting and like count. Liking a post updates
the count immediately, before the server confirms.

Installed versions stay in use for months, so the feed API must stay backward-compatible with them.
See the `mobile-api-compatibility` skill in `sharechat-ai-context`.

## Test

```
swift test
```
