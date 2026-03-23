import Foundation
import SwiftData

@Model
final class Expense {
    @Attribute(.unique) var id: UUID = UUID()
    var amount: Double = 0.0
    var note: String = ""
    var date: Date = Date.now
    var source: ExpenseSource

    @Relationship(deleteRule: .nullify)
    var category: Category?

    @Relationship(deleteRule: .nullify)
    var linkedBankTransaction: BankTransaction?

    enum ExpenseSource: String, Codable {
        case manual = "Manual"
        case bankImport = "Banco"
        case recurring = "Recurrente"
    }

    init(amount: Double, note: String, date: Date = .now, category: Category? = nil, source: ExpenseSource = .manual, linkedBankTransaction: BankTransaction? = nil) {
        self.amount = amount
        self.note = note
        self.date = date
        self.category = category
        self.source = source
        self.linkedBankTransaction = linkedBankTransaction
    }
}
