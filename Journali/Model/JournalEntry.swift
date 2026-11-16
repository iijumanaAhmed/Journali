//
//  JournalEntry.swift
//  Journali
//
//  Created by Jumana Khawaij on 07/06/1448 AH.
//
import SwiftUI

struct JournalEntry: Identifiable, Equatable {
    
    var id = UUID()
    var title: String
    var date: String
    var content: String
    var isBookmarked: Bool = false
}

enum JournalSortOption: Equatable {
    case bookmarks
    case date
}
