import Foundation

@MainActor
public final class FeedViewModel: ObservableObject {
    @Published public private(set) var items: [FeedItem] = []
    @Published public private(set) var errorMessage: String?
    @Published public private(set) var liked: Set<String> = []

    private let api: FeedAPI
    private let userId: String
    private let lang: String?
    private var nextCursor: String?

    public init(api: FeedAPI = FeedAPI(), userId: String = "u_1", lang: String? = "hi") {
        self.api = api
        self.userId = userId
        self.lang = lang
    }

    public func loadMore() async {
        do {
            let page = try await api.getFeed(userId: userId, lang: lang, cursor: nextCursor)
            items += page.items
            nextCursor = page.nextCursor
        } catch {
            errorMessage = "Couldn't load your feed. Pull to retry."
        }
    }

    /// Optimistic like: update the count immediately, then sync with the server.
    public func toggleLike(_ postId: String) {
        guard let index = items.firstIndex(where: { $0.postId == postId }) else { return }
        if liked.remove(postId) != nil {
            items[index].likeCount -= 1
        } else {
            liked.insert(postId)
            items[index].likeCount += 1
        }
    }
}
