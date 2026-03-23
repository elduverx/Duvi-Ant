import Foundation
import SwiftData

@MainActor
final class TransactionSyncService {
    private let financeStore: FinanceStoreProtocol
    private let modelContext: ModelContext

    init(modelContext: ModelContext, financeStore: FinanceStoreProtocol = MockFinanceStore()) {
        self.modelContext = modelContext
        self.financeStore = financeStore
    }

    // MARK: - Sync Transactions
    func syncTransactions(for account: BankAccount, from startDate: Date? = nil) async throws -> [BankTransaction] {
        let start = startDate ?? Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        let fkTransactions = try await financeStore.fetchTransactions(for: account.financeKitAccountID, from: start)

        var syncedTransactions: [BankTransaction] = []

        for fkTxn in fkTransactions {
            let transactionID = fkTxn.id
            let predicate = #Predicate<BankTransaction> { txn in
                txn.financeKitTransactionID == transactionID
            }

            let descriptor = FetchDescriptor<BankTransaction>(predicate: predicate)
            let existing = try? modelContext.fetch(descriptor).first

            if let existingTxn = existing {
                updateTransaction(existingTxn, with: fkTxn)
                syncedTransactions.append(existingTxn)
            } else {
                let newTxn = createTransaction(from: fkTxn, account: account)
                modelContext.insert(newTxn)
                syncedTransactions.append(newTxn)
                
                // Categorizar automáticamente
                await autoCategorize(newTxn)
            }
        }

        account.lastSynced = Date()
        try modelContext.save()
        return syncedTransactions
    }

    private func createTransaction(from fkTxn: FinanceTransactionProtocol, account: BankAccount) -> BankTransaction {
        BankTransaction(
            financeKitTransactionID: fkTxn.id,
            amount: fkTxn.amount,
            date: fkTxn.date,
            merchantName: fkTxn.merchantName,
            transactionDescription: fkTxn.transactionDescription,
            isIncome: fkTxn.isIncome,
            isPending: fkTxn.isPending,
            originalCategoryName: nil,
            account: account
        )
    }

    private func updateTransaction(_ txn: BankTransaction, with fkTxn: FinanceTransactionProtocol) {
        txn.isPending = fkTxn.isPending
        txn.amount = fkTxn.amount
    }

    // MARK: - Auto-Categorization Engine
    private func autoCategorize(_ transaction: BankTransaction) async {
        let descriptor = FetchDescriptor<Category>()
        guard let allCategories = try? modelContext.fetch(descriptor) else { return }

        // Mapeo detallado de comercios a categorías
        let mapping: [String: [String]] = [
            "Alimentación": [
                "starbucks", "cafe", "coffee", "cafeteria", "dunkin", "panaderia", "bakery",
                "mcdonald", "burger", "pizza", "kfc", "subway", "taco", "restaurant", "restaurante",
                "uber eats", "rappi", "pedidosya", "food", "comida",
                "walmart", "target", "carrefour", "mercadona", "oxxo", "7-eleven", "super", "market"
            ],
            "Transporte": [
                "uber", "lyft", "didi", "cabify", "taxi", "metro", "bus", "autobus", "train", "tren",
                "shell", "chevron", "repsol", "gas", "gasolina", "fuel", "parking", "estacionamiento"
            ],
            "Entretenimiento": [
                "netflix", "spotify", "disney", "hbo", "prime video", "apple music", "youtube",
                "cinema", "cine", "teatro", "theater", "gaming", "steam", "playstation", "xbox"
            ],
            "Suscripciones": [
                "apple.com/bill", "google storage", "icloud", "microsoft", "adobe", "canva", "zoom",
                "membership", "suscripcion", "monthly", "cuota"
            ],
            "Otros": [
                "amazon", "mercado libre", "ebay", "zara", "h&m", "nike", "adidas", "shopping"
            ]
        ]

        let searchString = (transaction.merchantName ?? "" + transaction.transactionDescription).lowercased()

        for (categoryName, keywords) in mapping {
            if keywords.contains(where: { searchString.contains($0) }) {
                transaction.category = allCategories.first { $0.name == categoryName }
                
                // Si encontramos un comercio específico como "Starbucks", podemos refinar la nota
                if searchString.contains("starbucks") || searchString.contains("cafe") {
                    transaction.notes = "☕️ Pago en cafetería"
                } else if searchString.contains("uber") || searchString.contains("lyft") {
                    transaction.notes = "🚗 Viaje solicitado"
                }
                
                break
            }
        }

        // Fallback: si no hay categoría, asignar "Otros"
        if transaction.category == nil {
            transaction.category = allCategories.first { $0.name == "Otros" }
        }
    }
}
