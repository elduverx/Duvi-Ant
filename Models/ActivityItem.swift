import Foundation

protocol ActivityItem {
    var id: UUID { get }
    var date: Date { get }
}

extension Expense: ActivityItem {}
extension BankTransaction: ActivityItem {}
