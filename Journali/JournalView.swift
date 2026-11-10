//
//  JournalView.swift
//  Journali
//
//  Created by Jumana Khawaij on 30/05/1448 AH.
//

import SwiftUI

struct JournalEntry: Identifiable {

    let id = UUID()
    var title: String
    var date: String
    var content: String
    var isBookmarked: Bool = false
}

// MARK: - Journal View
struct JournalView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @State private var searchText = ""
    @State private var showEditor = false
    @State private var showDeleteConfirmation = false
    @State private var selectedEntryID: UUID?
    
    @State private var journalEntries: [JournalEntry] = [
        
        JournalEntry(
            title: "My Birthday",
            date: "02/09/2024",
            content: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh viverra non semper suscipit posuere a pede."
        ),
        
        JournalEntry(
            title: "Today's Journal",
            date: "02/09/2024",
            content: "Today was a beautiful day. I enjoyed every moment."
        ),
        
        JournalEntry(
            title: "Great Day",
            date: "02/09/2024",
            content: "A wonderful memory worth remembering."
        ),
        
        JournalEntry(
            title: "A Beautiful Memory",
            date: "02/09/2024",
            content: "Some memories deserve to be written down and remembered forever."
        )
    ]
    
    //    @State private var journalEntries: [JournalEntry] = []
    
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
    
    // MARK: - Delete Journal
    
    private func deleteJournal() {
        guard let selectedEntryID else { return }
        
        withAnimation {
            journalEntries.removeAll { $0.id == selectedEntryID }
        }
        
        self.selectedEntryID = nil
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: Header
                HStack {
                    Text("Journal")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    HStack(spacing: 24) {
                        Button {
                            print("Filter tapped")
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease")
                                .font(.system(size: 25))
                                .foregroundStyle(.white)
                        }
                        
                        Button {
                            showEditor = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 27, weight: .medium))
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(Color.gray.opacity(0.20))
                    .clipShape(Capsule())
                }
                .padding(.top, 20)
                .padding(.bottom, 35)
                
                // MARK: Journal Entries
                if filteredEntries.isEmpty && searchText.isEmpty {
                    
                    GeometryReader { geometry in
                        
                        VStack(spacing: geometry.size.height * 0.025) {
                            
                            Image("book")
                                .resizable()
                                .scaledToFit()
                                .frame(
                                    width: min(geometry.size.width * 0.42, 190),
                                    height: min(geometry.size.height * 0.30, 190)
                                )
                            
                            Text("Begin Your Journal")
                                .font(
                                    .system(
                                        size: min(geometry.size.width * 0.065, 30),
                                        weight: .bold
                                    )
                                )
                                .foregroundStyle(Color(red: 0.686, green: 0.600, blue: 0.992))                                .multilineTextAlignment(.center)
                            
                            Text("Craft your personal diary, tap the plus icon to begin")
                                .font(
                                    .system(
                                        size: min(geometry.size.width * 0.038, 18)
                                    )
                                )
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: 350)
                        }
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .center
                        )
                    }
                    
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredEntries) { entry in

                                ForEach(filteredEntries) { entry in

                                    JournalCard(
                                        title: entry.title,
                                        date: entry.date,
                                        content: entry.content,
                                        isBookmarked: entry.isBookmarked,

                                        // Bookmark
                                        onBookmark: {
                                            if let index = journalEntries.firstIndex(
                                                where: { $0.id == entry.id }
                                            ) {
                                                journalEntries[index].isBookmarked.toggle()
                                            }
                                        },

                                        // Edit
                                        onEdit: {
                                            showEditor = true
                                        },

                                        // Delete
                                        onDelete: {
                                            selectedEntryID = entry.id
                                            showDeleteConfirmation = true
                                        }
                                    )
                                }

                            }
                        }
                        .padding(.bottom, 20)
                    }
                }
                
            }
            .frame(maxWidth: 620)
            .padding(.horizontal,
                     horizontalSizeClass == .regular ? 32 : 22)
            .frame(maxWidth: .infinity)
        }
        
        // MARK: Search Bar
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
                    .stroke(
                        Color.gray.opacity(0.35),
                        lineWidth: 1
                    )
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 10)
        }
        
        // MARK: Editor Sheet
        .sheet(isPresented: $showEditor) {
            JournalEditorView { title, content, date in
                
                let newEntry = JournalEntry(
                    title: title,
                    date: date,
                    content: content
                )
                
                journalEntries.insert(newEntry, at: 0)
            }
            .preferredColorScheme(.dark)
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(32)
        }
    }
}




// MARK: - Journal Card

struct JournalCard: View {
    
    let title: String
    let date: String
    let content: String
    let isBookmarked: Bool
    
    let onBookmark: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGFloat = 0
    private let deleteButtonWidth: CGFloat = 100
    
    var body: some View {
        ZStack(alignment: .trailing) {
            // MARK: Delete Button
            Button {
                onDelete()
            } label: {
                Image(systemName: "trash")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(width: deleteButtonWidth, height: 80)
                    .background(Color(red: 1.0, green: 0.25, blue: 0.23))
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            
            // MARK: Journal Content
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(title)
                            .font(.system(size: 29, weight: .semibold))
                            .foregroundStyle(
                                Color(red: 0.68, green: 0.57, blue: 1.0)
                            )
                        
                        Text(date)
                            .font(.system(size: 14))
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                    
                    // MARK: Bookmark Button
                    Button {
                        onBookmark()
                    } label: {
                        Image(systemName: isBookmarked
                              ? "bookmark.fill"
                              : "bookmark")
                        .font(.system(size: 30))
                        .foregroundStyle(
                            Color(red: 0.68, green: 0.57, blue: 1.0)
                        )
                    }
                    .buttonStyle(.plain)
                }
                
                Text(content)
                    .font(.system(size: 18))
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
            .contentShape(RoundedRectangle(cornerRadius: 38))
            .onTapGesture {
                if offset == 0 {
                    onEdit()
                } else {
                    withAnimation(.spring(response: 0.3)) {
                        offset = 0
                    }
                }
            }
            .gesture(
                DragGesture(minimumDistance: 20)
                    .onChanged { value in
                        
                        guard abs(value.translation.width) >
                                abs(value.translation.height) else {
                            return
                        }
                        
                        let newOffset = value.translation.width
                        
                        offset = min(
                            0,
                            max(newOffset, -deleteButtonWidth)
                        )
                    }
                    .onEnded { value in
                        
                        withAnimation(.spring(response: 0.3)) {
                            if value.translation.width < -40 {
                                offset = -deleteButtonWidth
                            } else {
                                offset = 0
                            }
                        }
                    }
            )
            
        }
        .clipShape(RoundedRectangle(cornerRadius: 38))
    }
}

// MARK: - Preview
#Preview {
    JournalView()
}
