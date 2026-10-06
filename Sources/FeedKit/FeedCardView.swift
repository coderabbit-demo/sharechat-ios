import SwiftUI

public struct FeedView: View {
    @StateObject private var vm = FeedViewModel()

    public init() {}

    public var body: some View {
        List {
            if let message = vm.errorMessage {
                Text(message).foregroundStyle(.secondary)
            }
            ForEach(vm.items) { item in
                FeedCardView(item: item, liked: vm.liked.contains(item.postId)) {
                    vm.toggleLike(item.postId)
                }
            }
        }
        .listStyle(.plain)
        .task { await vm.loadMore() }
        .refreshable { await vm.loadMore() }
    }
}

struct FeedCardView: View {
    let item: FeedItem
    let liked: Bool
    let onLike: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                AsyncImage(url: item.author.avatarUrl) { $0.resizable() } placeholder: { Color.gray.opacity(0.3) }
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                Text("@\(item.author.handle)").font(.subheadline.bold())
                Spacer()
                Text(timeAgo(item.createdAt)).font(.caption).foregroundStyle(.secondary)
            }

            if item.media.type == "image" || item.media.type == "video" {
                AsyncImage(url: item.media.url) { $0.resizable().scaledToFill() } placeholder: { Color.gray.opacity(0.2) }
                    .frame(maxWidth: .infinity)
                    .aspectRatio(1, contentMode: .fit)
                    .clipped()
            }

            if let caption = item.caption {
                Text(caption)
            }

            Button(action: onLike) {
                Text("\(liked ? "♥" : "♡") \(formatLikes(item.likeCount))")
            }
            .buttonStyle(.borderless)
        }
        .padding(.vertical, 8)
    }
}

/// Indian compact format: 1,240,000 → "12.4L", 48,300 → "48.3K".
func formatLikes(_ count: Int) -> String {
    switch count {
    case 10_000_000...: return String(format: "%.1fCr", Double(count) / 10_000_000)
    case 100_000...: return String(format: "%.1fL", Double(count) / 100_000)
    case 1_000...: return String(format: "%.1fK", Double(count) / 1_000)
    default: return String(count)
    }
}

func timeAgo(_ date: Date, now: Date = Date()) -> String {
    let minutes = Int(now.timeIntervalSince(date) / 60)
    if minutes >= 24 * 60 { return "\(minutes / (24 * 60))d" }
    if minutes >= 60 { return "\(minutes / 60)h" }
    return "\(minutes)m"
}
