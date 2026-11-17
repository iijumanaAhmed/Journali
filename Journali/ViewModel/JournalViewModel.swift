import SwiftUI
import Combine

class JournalViewModel: ObservableObject {
        
    @Published var journalEntries: [JournalEntry] = [
        JournalEntry(
            title: "A Beautiful Day",
            date: "17/11/2026",
            content: "Today was such a lovely day. I spent time with my friends, enjoyed a good coffee, and felt grateful for the little things in life.",
            isBookmarked: true
        ),
        
        JournalEntry(
            title: "Finding Myself",
            date: "15/11/2026",
            content: "Lately, I have been thinking about my goals and the person I want to become. I want to focus more on myself and enjoy the journey."
        ),
        
        JournalEntry(
            title: "Small Achievements",
            date: "12/11/2026",
            content: "I finally completed a task that I had been postponing for weeks. It feels good to make progress, even when it is just a small step.",
            isBookmarked: true
        ),
        
        JournalEntry(
            title: "A Little Overwhelmed",
            date: "10/11/2026",
            content: "There is so much happening around me right now. I need to slow down, take a deep breath, and remind myself that everything takes time."
        ),
        
        JournalEntry(
            title: "Weekend Memories",
            date: "08/11/2026",
            content: "I had a wonderful weekend with my family. We laughed, shared stories, and made memories that I hope to remember for a long time."
        ),
        
        JournalEntry(
            title: "Dear Future Me",
            date: "05/11/2026",
            content: "I hope you are proud of how far you have come. Keep believing in yourself, stay curious, and never forget to appreciate your progress.",
            isBookmarked: true
        ),
        
        JournalEntry(
            title: "A Fresh Start",
            date: "01/11/2026",
            content: "A new month means new opportunities. I want to build better habits, read more books, and make more time for the things I love."
        )
    ]
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    @Published var sortOption: JournalSortOption = .date
    func filteredEntries(searchText: String) -> [JournalEntry] {
        
        guard !searchText.isEmpty else {
            return journalEntries
        }
        
        return journalEntries.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.content.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    func addJournal(title: String, content: String, date: String) {
        
        let newEntry = JournalEntry(
            title: title,
            date: date,
            content: content
        )
        
        journalEntries.insert(newEntry, at: 0)
    }
    
    func updateJournal(
        id: UUID,
        title: String,
        content: String,
        date: String
    ) {
        guard let index = journalEntries.firstIndex(where: {
            $0.id == id
        }) else { return }

        let dateChanged = journalEntries[index].date != date

        journalEntries[index].title = title
        journalEntries[index].content = content
        journalEntries[index].date = date

        if sortOption == .date && dateChanged {
            sortJournal(by: .date)
        }
    }
    
    func deleteJournal(id: UUID) {
        
        withAnimation {
            journalEntries.removeAll {
                $0.id == id
            }
        }
    }
    
    func toggleBookmark(for id: UUID) {
        
        withAnimation {
            guard let index = journalEntries.firstIndex(where: {
                $0.id == id
            }) else { return }
            
            journalEntries[index].isBookmarked.toggle()
            
            if sortOption == .bookmarks {
                sortJournal(by: sortOption)
            }
        }
    }
    
    func sortJournal(by option: JournalSortOption) {
        
        sortOption = option
        
        withAnimation {
            
            switch sortOption {
                
            case .bookmarks:
                journalEntries.sort {
                    $0.isBookmarked && !$1.isBookmarked
                }
                
            case .date:
                let sortedEntries = journalEntries.map { entry in
                    (
                        entry: entry,
                        parsedDate: Self.dateFormatter.date(from: entry.date) ?? .distantPast
                    )
                }

                journalEntries = sortedEntries
                    .sorted { $0.parsedDate > $1.parsedDate }
                    .map { $0.entry }
            }
        }
    }
}
