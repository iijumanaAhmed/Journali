import Foundation

struct JournalEntry: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var date: String
    var content: String
    var isBookmarked: Bool = false
}

struct JournalEditorSheet: Identifiable {
    let id = UUID()
    let entry: JournalEntry?
}

enum JournalSortOption {
    case bookmarks
    case date
}
