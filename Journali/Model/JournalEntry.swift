//
//  JournalEntry.swift
//  Journali
//
//  Created by Jumana Khawaij on 07/06/1448 AH.
//
import Foundation
struct JournalEntry: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var date: String
    var content: String
    var isBookmarked: Bool = false
}

enum JournalSortOption {
    case bookmarks
    case date
}
