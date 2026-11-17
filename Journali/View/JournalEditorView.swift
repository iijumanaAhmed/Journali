import SwiftUI

struct JournalEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    private let entry: JournalEntry?
    private var isTitleEmpty: Bool {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    let onSave: (String, String, String) -> Void
    
    @State private var title: String
    @State private var journalText: String
    @State private var showDiscardAlert = false
    
    init(
        entry: JournalEntry? = nil,
        onSave: @escaping (String, String, String) -> Void
    ) {
        self.entry = entry
        self.onSave = onSave
        
        _title = State(initialValue: entry?.title ?? "")
        _journalText = State(initialValue: entry?.content ?? "")
    }
    
    private var currentDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        return formatter.string(from: Date())
    }
    
    private var displayDate: String { currentDate }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Button {
                        showDiscardAlert = true
                    } label: {
                        
                        Image(systemName: "xmark")
                            .font(.system(size: 23))
                            .foregroundStyle(.white)
                            .frame(width: 56, height: 56)
                            .background(Color.black.opacity(0.25))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
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
                            .font(.system(size: 26, weight: .medium))
                            .foregroundStyle(.black)
                            .frame(width: 56, height: 56)
                            .background(
                                Color(red: 0.52, green: 0.48, blue: 1.0)
                            )
                            .clipShape(Circle())
                    }
                    .disabled(isTitleEmpty)
                    .opacity(isTitleEmpty ? 0.5 : 1)
                }
                
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
        .alert("Discard Changes?", isPresented: $showDiscardAlert) {
            
            Button("Discard Changes", role: .destructive) {
                dismiss()
            }
            
            Button("Keep Editing", role: .cancel) {
                // Stay in the editor
            }
            
        } message: {
            Text("Are you sure you want to discard changes on this journal?")
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
