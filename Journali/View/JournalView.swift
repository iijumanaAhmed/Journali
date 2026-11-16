//
//  JournalView.swift
//  Journali
//
//  Created by Jumana Khawaij on 07/06/1448 AH.
//
import SwiftUI

struct JournalView: View {
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @StateObject private var viewModel = JournalViewModel()
    
    // UI States
    @State private var searchText = ""
    @State private var showEditor = false
    @State private var selectedJournal: JournalEntry?
    
    @State private var showDeleteConfirmation = false
    @State private var selectedEntryID: UUID?
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                VStack {
                    
                    if viewModel.filteredEntries(searchText: searchText).isEmpty
                        && searchText.isEmpty {
                        
                        GeometryReader { geometry in
                            VStack(spacing: geometry.size.height * 0.015) {
                                
                                Image("book")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(
                                        width: min(geometry.size.width * 0.50, 190),
                                        height: min(geometry.size.height * 0.35, 190)
                                    )
                                
                                Text("Begin Your Journal")
                                    .font(
                                        .system(
                                            size: min(geometry.size.width * 0.075, AppFonts.headingL),
                                            weight: .bold
                                        )
                                    )
                                    .foregroundStyle(Color.accentText)
                                    .multilineTextAlignment(.center)
                                
                                Text("Craft your personal diary, tap the\n plus icon to begin")
                                    .font(
                                        .system(
                                            size: min(geometry.size.width * 0.038, AppFonts.bodyM),
                                            weight: .light
                                        )
                                    )
                                    .foregroundStyle(Color.primaryText)
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
                                
                                ForEach(viewModel.filteredEntries(searchText: searchText)) { entry in
                                    
                                    JournalCard(
                                        title: entry.title,
                                        date: entry.date,
                                        content: entry.content,
                                        isBookmarked: entry.isBookmarked,
                                        
                                        onTap: {
                                            selectedJournal = entry
                                            showEditor = true
                                        },
                                        
                                        onToggleBookmark: {
                                            viewModel.toggleBookmark(for: entry.id)
                                        },
                                        
                                        onDelete: {
                                            selectedEntryID = entry.id
                                            showDeleteConfirmation = true
                                        }
                                    )
                                }
                            }
                            .padding(.top, 20)
                        }
                    }
                }
                .frame(maxWidth: 620)
                .padding(.horizontal,
                         horizontalSizeClass == .regular ? 32 : 24)
                .frame(maxWidth: .infinity)
            }
            
            // MARK: - Search
            
            .searchable(
                text: $searchText,
                placement: .automatic,
                prompt: "Search"
            )
            
            // MARK: - Editor
            
            .sheet(isPresented: $showEditor) {
                
                JournalEditorView(entry: selectedJournal) { title, content, date in
                    
                    if let selectedJournal {
                        
                        viewModel.updateJournal(
                            id: selectedJournal.id,
                            title: title,
                            content: content,
                            date: date
                        )
                        
                    } else {
                        
                        viewModel.addJournal(
                            title: title,
                            content: content,
                            date: date
                        )
                    }
                    
                    self.selectedJournal = nil
                }
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(32)
            }
            
            // MARK: - Delete Alert
            
            .alert("Delete Journal?", isPresented: $showDeleteConfirmation) {
                
                Button("Cancel", role: .cancel) {
                    selectedEntryID = nil
                }
                
                Button("Delete", role: .destructive) {
                    if let id = selectedEntryID {
                        viewModel.deleteJournal(id: id)
                    }
                    selectedEntryID = nil
                }
                
            } message: {
                Text("Are you sure you want to delete this journal?")
            }
            
            // MARK: - Toolbar
            
            .toolbar {
                
                ToolbarItem(placement: .principal) {
                    Text("Journal")
                        .font(.system(size: AppFonts.headingL, weight: .bold))
                        .foregroundStyle(Color.primaryText)
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    
                    Menu {
                        
                        Button("Sort by Bookmark") {
                            viewModel.sortJournal(by: .bookmarks)
                        }
                        
                        Button("Sort by Entry Date") {
                            viewModel.sortJournal(by: .date)
                        }
                        
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.primaryText)
                    }
                    
                    Button {
                        selectedJournal = nil
                        showEditor = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundStyle(Color.primaryText)
                    }
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


#Preview {
    JournalView()
        .preferredColorScheme(.dark)
}

