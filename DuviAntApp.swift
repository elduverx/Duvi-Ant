import SwiftUI
import SwiftData

@main
struct DuviAntApp: App {
    private static let storeURL: URL = {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = base.appendingPathComponent("DuviAntData", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("duviant.store")
    }()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Expense.self,
            Category.self,
            Budget.self,
            RecurringExpense.self,
            SavingsGoal.self,
            PushAlert.self,
            BankAccount.self,
            BankTransaction.self
        ])

        let config = ModelConfiguration(schema: schema, url: storeURL)

        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            // If a previous incompatible schema exists, recreate the local store.
            resetStoreFiles(at: storeURL)
            do {
                return try ModelContainer(for: schema, configurations: [config])
            } catch {
                fatalError("Could not create ModelContainer after reset: \(error)")
            }
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(sharedModelContainer)
    }

    private static func resetStoreFiles(at url: URL) {
        let fm = FileManager.default
        let candidates = [
            url,
            URL(fileURLWithPath: url.path + "-shm"),
            URL(fileURLWithPath: url.path + "-wal")
        ]

        for fileURL in candidates where fm.fileExists(atPath: fileURL.path) {
            try? fm.removeItem(at: fileURL)
        }
    }
}
