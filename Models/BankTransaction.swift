import Foundation
import SwiftData

@Model
final class BankTransaction {
    @Attribute(.unique) var id: UUID
    var financeKitTransactionID: String
    var amount: Double
    var date: Date
    var merchantName: String?
    var transactionDescription: String
    var isIncome: Bool
    var isPending: Bool
    var originalCategoryName: String?

    @Relationship(deleteRule: .nullify)
    var account: BankAccount?

    @Relationship(deleteRule: .nullify)
    var category: Category?

    @Relationship(deleteRule: .nullify)
    var linkedExpense: Expense?

    var isIgnored: Bool
    var notes: String?

    init(
        financeKitTransactionID: String,
        amount: Double,
        date: Date,
        merchantName: String? = nil,
        transactionDescription: String,
        isIncome: Bool = false,
        isPending: Bool = false,
        originalCategoryName: String? = nil,
        account: BankAccount? = nil
    ) {
        self.id = UUID()
        self.financeKitTransactionID = financeKitTransactionID
        self.amount = amount
        self.date = date
        self.merchantName = merchantName
        self.transactionDescription = transactionDescription
        self.isIncome = isIncome
        self.isPending = isPending
        self.originalCategoryName = originalCategoryName
        self.account = account
        self.isIgnored = false
    }

    // MARK: - Computed Properties

    var isCurrentMonth: Bool {
        let calendar = Calendar.current
        let now = Date()
        return calendar.isDate(date, equalTo: now, toGranularity: .month)
    }

    var displayAmount: Double {
        isIncome ? amount : abs(amount)
    }
}
