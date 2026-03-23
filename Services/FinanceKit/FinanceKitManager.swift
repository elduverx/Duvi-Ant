import Foundation
import SwiftData

@Observable
@MainActor
final class FinanceKitManager {
    let authManager: FinanceKitAuthManager
    let accountService: BankAccountService
    let transactionService: TransactionSyncService

    var isSyncing = false
    var lastSyncDate: Date?
    var syncError: Error?

    init(modelContext: ModelContext) {
        #if targetEnvironment(simulator)
        let financeStore: FinanceStoreProtocol = MockFinanceStore()
        #else
        let financeStore: FinanceStoreProtocol = RealFinanceStore()
        #endif
        
        self.authManager = FinanceKitAuthManager(financeStore: financeStore)
        self.accountService = BankAccountService(modelContext: modelContext, financeStore: financeStore)
        self.transactionService = TransactionSyncService(modelContext: modelContext, financeStore: financeStore)
    }

    // MARK: - Full Sync
    func performFullSync() async {
        if !authManager.isAuthorized {
            await authManager.requestAuthorization()
        }

        guard authManager.isAuthorized else {
            syncError = NSError(domain: "FinanceKit", code: 401, userInfo: [NSLocalizedDescriptionKey: "No autorizado para acceder a FinanceKit"])
            return
        }

        isSyncing = true
        defer { isSyncing = false }

        do {
            // 1. Sync accounts
            let accounts = try await accountService.syncAccounts()

            // 2. Sync transactions for each account
            for account in accounts where account.isActive {
                _ = try await transactionService.syncTransactions(for: account)
            }

            lastSyncDate = Date()
            syncError = nil
        } catch {
            syncError = error
            print("FinanceKit sync error: \(error)")
        }
    }
}
