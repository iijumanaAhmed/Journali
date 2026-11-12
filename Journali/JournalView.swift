
import SwiftUI


struct JournalEntry: Identifiable, Codable, Equatable {

    var id: UUID = UUID()
    var title: String
    var date: String
    var content: String
    var isBookmarked: Bool = false
}

enum JournalSortOption: Equatable {
    case bookmarks
    case date
}

struct JournalView: View {
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @State private var searchText = ""
    @State private var showEditor = false
    @State private var selectedJournal: JournalEntry?
    @State private var journalEntries: [JournalEntry] = []
    
    @State private var showDeleteConfirmation = false
    @State private var selectedEntryID: UUID?
    // MARK: - Delete Journal
    private func deleteJournal() {
        guard let selectedEntryID else { return }

        withAnimation {
            journalEntries.removeAll { $0.id == selectedEntryID }
        }

        self.selectedEntryID = nil
    }
    
    // MARK: - Edit Journal
    private func updateJournal(
        id: UUID,
        title: String,
        content: String,
        date: String
    ) {

        guard let index = journalEntries.firstIndex(where: {
            $0.id == id
        }) else { return }

        journalEntries[index].title = title
        journalEntries[index].content = content
        journalEntries[index].date = date

        if sortOption == .date {
            sortJournal()
        }
    }
    
    // MARK: - Filtered Entries
    private var filteredEntries: [JournalEntry] {

        guard !searchText.isEmpty else {
            return journalEntries
        }

        return journalEntries.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.content.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    @State private var sortOption: JournalSortOption = .date
    
    // MARK: - Sort Journal Entries
    private func sortJournal() {

        withAnimation {
            switch sortOption {

            case .bookmarks:
                journalEntries.sort {
                    $0.isBookmarked && !$1.isBookmarked
                }

            case .date:
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"

                journalEntries.sort {
                    let date1 = formatter.date(from: $0.date) ?? .distantPast
                    let date2 = formatter.date(from: $1.date) ?? .distantPast

                    return date1 < date2
                }
            }
        }
    }
    
    // MARK: - Toggle Bookmark
    private func toggleBookmark(for id: UUID) {

        withAnimation {
            guard let index = journalEntries.firstIndex(where: {
                $0.id == id
            }) else { return }

            journalEntries[index].isBookmarked.toggle()

            // Keep bookmarked entries at the top if sorting by bookmarks
            if sortOption == .bookmarks {
                sortJournal()
            }
        }
    }
    
    
    // MARK: - Open Journal Editor

    private func editJournal(_ entry: JournalEntry) {
        selectedJournal = entry
        showEditor = true
    }
    var body: some View {
        
        ZStack {
            
            // Background
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // Header
                HStack {
                    
                    Text("Journal")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    HStack(spacing: 24) {
                        
                        // MARK: Sorting Menu
                        Menu {

                            Button {
                                sortOption = .bookmarks
                                sortJournal()
                            } label: {
                                Label("Sort by Bookmarks", systemImage: "bookmark.fill")
                            }

                            Button {
                                sortOption = .date
                                sortJournal()
                            } label: {
                                Label("Sort by Entry Date", systemImage: "calendar")
                            }

                        } label: {
                            Image(systemName: "line.3.horizontal.decrease")
                                .font(.system(size: 25))
                                .foregroundStyle(.white)
                        }
                        
                        Button {
                            selectedJournal = nil
                            showEditor = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 27, weight: .medium))
                                .foregroundStyle(.white)
                        }                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(Color.gray.opacity(0.20))
                    .clipShape(Capsule())
                }
                .padding(.top, 20)
                .padding(.bottom, 35)
                
                // Journal entries
                ScrollView {
                    
                    LazyVStack(spacing: 16) {
                        ForEach(filteredEntries) { entry in
                            JournalCard(
                                title: entry.title,
                                date: entry.date,
                                content: entry.content,
                                isBookmarked: entry.isBookmarked,
                                onTap: {
                                    editJournal(entry)
                                },
                                onToggleBookmark: {
                                    toggleBookmark(for: entry.id)
                                },
                                onDelete: {
                                    selectedEntryID = entry.id
                                    showDeleteConfirmation = true
                                }
                            )
                        }
                    }
                }
            }
            .frame(maxWidth: 620)
            .padding(.horizontal,
                     horizontalSizeClass == .regular ? 32 : 24)
            .frame(maxWidth: .infinity)
            
        }
        // Floating search bar
        .safeAreaInset(edge: .bottom) {
            
            HStack {
                
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 23))
                    .foregroundStyle(.gray)
                
                TextField("Search", text: $searchText)
                    .foregroundStyle(.white)
                
                Image(systemName: "mic")
                    .font(.system(size: 22))
                    .foregroundStyle(.gray)
            }
            .padding(14)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
            .overlay {
                Capsule()
                    .stroke(Color.gray.opacity(0.35), lineWidth: 1)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 10)
        }
        .sheet(isPresented: $showEditor) {

            JournalEditorView(entry: selectedJournal) { title, content, date in

                if let selectedJournal {

                    // Update existing journal
                    updateJournal(
                        id: selectedJournal.id,
                        title: title,
                        content: content,
                        date: date
                    )

                } else {

                    // Create new journal
                    let newEntry = JournalEntry(
                        title: title,
                        date: date,
                        content: content
                    )

                    journalEntries.insert(newEntry, at: 0)
                }

                self.selectedJournal = nil
            }
            .preferredColorScheme(.dark)
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(32)
        }
        .alert("Delete Journal?", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) {
                selectedEntryID = nil
            }

            Button("Delete", role: .destructive) {
                deleteJournal()
            }
        } message: {
            Text("Are you sure you want to delete this journal? This action cannot be undone.")
        }
        .onAppear {

            // Load previously saved journals
            if let savedEntries = JournalStorage.load() {
                journalEntries = savedEntries
            } else {
                // Save initial entries on first launch
                JournalStorage.save(journalEntries)
            }
        }
        .onChange(of: journalEntries) { _, updatedEntries in

            // Automatically save whenever journals change
            JournalStorage.save(updatedEntries)
        }
    }
}

// MARK: - Journal Card
struct JournalCard: View {

    let title: String
    let date: String
    let content: String
    let isBookmarked: Bool

    let onTap: () -> Void
    let onToggleBookmark: () -> Void
    let onDelete: () -> Void

    @State private var offset: CGFloat = 0

    private let deleteButtonWidth: CGFloat = 100

    var body: some View {

        ZStack(alignment: .trailing) {

            // MARK: Delete Button

            Button {
                onDelete()
            } label: {
                VStack(spacing: 8) {
                    Image(systemName: "trash")
                        .font(.system(size: 22))

                    Text("Delete")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundStyle(.white)
                .frame(width: deleteButtonWidth)
                .frame(maxHeight: .infinity)
                .background(Color.red)
                .clipShape(RoundedRectangle(cornerRadius: 28))
            }

            // MARK: Journal Content

            VStack(alignment: .leading, spacing: 0) {

                HStack(alignment: .top) {

                    VStack(alignment: .leading, spacing: 6) {

                        Text(title)
                            .font(.system(size: 29, weight: .semibold))
                            .foregroundStyle(
                                Color(red: 0.68, green: 0.57, blue: 1.0)
                            )

                        Text(date)
                            .font(.system(size: 18))
                            .foregroundStyle(.gray)
                    }

                    Spacer()

                    Button {
                        onToggleBookmark()
                    } label: {
                        Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                            .font(.system(size: 25))
                            .foregroundStyle(
                                Color(red: 0.68, green: 0.57, blue: 1.0)
                            )
                            .contentTransition(.symbolEffect(.replace))
                    }
                    .buttonStyle(.plain)
                }

                Text(content)
                    .font(.system(size: 21))
                    .foregroundStyle(.white)
                    .lineSpacing(2)
                    .lineLimit(5)
                    .padding(.top, 28)
            }
            .padding(28)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(red: 0.11, green: 0.11, blue: 0.12))
            .clipShape(RoundedRectangle(cornerRadius: 38))
            .offset(x: offset)
            .gesture(
                DragGesture(minimumDistance: 20)
                    .onChanged { value in

                        // Only respond to horizontal movement
                        guard abs(value.translation.width) >
                                abs(value.translation.height) else {
                            return
                        }

                        let newOffset = value.translation.width

                        if newOffset < 0 {
                            offset = max(
                                newOffset,
                                -deleteButtonWidth
                            )
                        }
                    }
                    .onEnded { value in

                        if value.translation.width < -40 {
                            offset = -deleteButtonWidth
                        } else if value.translation.width > 40 {
                            offset = 0
                        }
                    }
            )
            .animation(.spring(response: 0.3), value: offset)
        }
        .clipShape(RoundedRectangle(cornerRadius: 38))
        .onTapGesture {
            if offset == 0 {
                onTap()
            }
        }
    }
}



#Preview {
    JournalView()
        .preferredColorScheme(.dark)
}
