
import SwiftUI

struct JournalEditorView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    // MARK: - Journal Data

    private let entry: JournalEntry?
    let onSave: (String, String, String) -> Void

    @State private var title: String
    @State private var journalText: String

    // MARK: - Initializer

    init(
        entry: JournalEntry? = nil,
        onSave: @escaping (String, String, String) -> Void
    ) {
        self.entry = entry
        self.onSave = onSave

        _title = State(initialValue: entry?.title ?? "")
        _journalText = State(initialValue: entry?.content ?? "")
    }

    // MARK: - Date

    private var currentDate: String {

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"

        return formatter.string(from: Date())
    }

    // Preserve the original date when editing
    private var displayDate: String {
        currentDate
    }

    // MARK: - Body

    var body: some View {

        ZStack {

            Color(red: 0.11, green: 0.11, blue: 0.12)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {

                // Top buttons

                HStack {

                    Button {
                        dismiss()
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

                        onSave(title, journalText, displayDate)
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
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                    .opacity(
                        title.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1
                    )
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
    }
}

// MARK: - Preview

#Preview {

    JournalEditorView { title, content, date in
        print(title, content, date)
    }
    .preferredColorScheme(.dark)
}
