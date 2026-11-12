
import Foundation

enum JournalStorage {

    // MARK: - File Location

    private static var fileURL: URL {

        FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0].appendingPathComponent("journals.json")
    }

    // MARK: - Save Journals

    static func save(_ journals: [JournalEntry]) {

        do {
            let data = try JSONEncoder().encode(journals)

            try data.write(
                to: fileURL,
                options: .atomic
            )

        } catch {
            print("Failed to save journals: \(error)")
        }
    }

    // MARK: - Load Journals

    static func load() -> [JournalEntry]? {

        do {
            let data = try Data(contentsOf: fileURL)

            return try JSONDecoder().decode(
                [JournalEntry].self,
                from: data
            )

        } catch {
            print("Failed to load journals: \(error)")
            return nil
        }
    }
}
