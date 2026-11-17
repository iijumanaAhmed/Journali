import SwiftUI

struct JournalEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    let onSave: (String, String, String) -> Void
    
    @State private var title: String
    @State private var journalText: String
    @State private var showDiscardAlert = false
    
    private let initialTitle: String
    private let initialJournalText: String

    private var hasUnsavedChanges: Bool {
        title != initialTitle || journalText != initialJournalText
    }
    
    private var isTitleEmpty: Bool {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - Initialization
    init(
        entry: JournalEntry? = nil,
        onSave: @escaping (String, String, String) -> Void
    ) {
        self.onSave = onSave

        initialTitle = entry?.title ?? ""
        initialJournalText = entry?.content ?? ""

        _title = State(initialValue: initialTitle)
        _journalText = State(initialValue: initialJournalText)
    }
    
    // MARK: - Date Formatting
    private var currentDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        return formatter.string(from: Date())
    }
    
    private var displayDate: String { currentDate }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    // Title
                    TextField("Title", text: $title)
                        .font(.system(size: 38, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.top, 16)
                    
                    // Date
                    Text(displayDate)
                        .font(.system(size: 20))
                        .foregroundStyle(.gray)
                        .padding(.top, 10)
                    
                    // Journal content
                    ZStack(alignment: .topLeading) {
                        if journalText.isEmpty {
                            
                            Text("Type your Journal...")
                                .font(.system(size: 22))
                                .foregroundStyle(.gray.opacity(0.6))
                                .padding(.top, 8)
                                .padding(.leading, 5)
                        }
                        
                        TextEditor(text: $journalText)
                            .font(.system(size: 21))
                            .foregroundStyle(.white)
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                    }
                    .padding(.top, 25)
                    
                    Spacer(minLength: 0)
                }
                .frame(maxWidth: 760)
                .padding(.horizontal,
                         horizontalSizeClass == .regular ? 40 : 20)
                .padding(.top, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            .toolbar {
                // Close Button
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        if hasUnsavedChanges {
                            showDiscardAlert = true
                        } else {
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: AppFonts.bodyL, weight: .medium))
                    }
                    .alert("", isPresented: $showDiscardAlert) {
                        Button("Discard Changes", role: .destructive) {
                            dismiss()
                        }

                        Button("Keep Editing", role: .cancel) {}
                    } message: {
                        Text("Are you sure you want to discard changes on this journal?")
                    }
                }
                
                // Save Button
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        guard !isTitleEmpty else { return }
                        
                        onSave(
                            title.trimmingCharacters(in: .whitespacesAndNewlines),
                            journalText,
                            displayDate
                        )
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.system(size: AppFonts.bodyL, weight: .medium))
                            .foregroundStyle(.black)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.circle)
                    .tint(Color.accentText)
                    .disabled(isTitleEmpty)
                    .opacity(isTitleEmpty ? 0.5 : 1)
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Preview
#Preview {
    JournalEditorView { title, content, date in
        print(title, content, date)
    }
    .preferredColorScheme(.dark)
}
