import Foundation
import SwiftData

@Model
final class BankAccount {
    @Attribute(.unique) var id: UUID
    var financeKitAccountID: String
    var institutionName: String
    var accountType: AccountType
    var displayName: String?
    var lastFourDigits: String?
    var currentBalance: Double
    var availableCredit: Double?
    var creditLimit: Double?
    var lastSynced: Date
    var isActive: Bool
    var color: String
    var iconName: String

    @Relationship(deleteRule: .cascade, inverse: \BankTransaction.account)
    var transactions: [BankTransaction] = []

    enum AccountType: String, Codable {
        case checking = "Cuenta Corriente"
        case savings = "Ahorro"
        case creditCard = "Tarjeta de Crédito"
        case debit = "Débito"
        case unknown = "Desconocido"
    }

    init(
        financeKitAccountID: String,
        institutionName: String,
        accountType: AccountType,
        displayName: String? = nil,
        lastFourDigits: String? = nil,
        currentBalance: Double = 0.0,
        availableCredit: Double? = nil,
        creditLimit: Double? = nil,
        color: String = "blue",
        iconName: String = "creditcard.fill"
    ) {
        self.id = UUID()
        self.financeKitAccountID = financeKitAccountID
        self.institutionName = institutionName
        self.accountType = accountType
        self.displayName = displayName
        self.lastFourDigits = lastFourDigits
        self.currentBalance = currentBalance
        self.availableCredit = availableCredit
        self.creditLimit = creditLimit
        self.lastSynced = Date()
        self.isActive = true
        self.color = color
        self.iconName = iconName
    }

    // MARK: - Computed Properties

    var monthIncome: Double {
        let calendar = Calendar.current
        let now = Date()
        let currentMonth = calendar.component(.month, from: now)
        let currentYear = calendar.component(.year, from: now)

        return transactions.filter { transaction in
            transaction.isIncome &&
            calendar.component(.month, from: transaction.date) == currentMonth &&
            calendar.component(.year, from: transaction.date) == currentYear
        }.reduce(0) { $0 + $1.amount }
    }

    var monthExpenses: Double {
        let calendar = Calendar.current
        let now = Date()
        let currentMonth = calendar.component(.month, from: now)
        let currentYear = calendar.component(.year, from: now)

        return transactions.filter { transaction in
            !transaction.isIncome &&
            calendar.component(.month, from: transaction.date) == currentMonth &&
            calendar.component(.year, from: transaction.date) == currentYear
        }.reduce(0) { $0 + abs($1.amount) }
    }

    var recentTransactions: [BankTransaction] {
        Array(transactions
            .sorted { $0.date > $1.date }
            .prefix(10))
    }
}
