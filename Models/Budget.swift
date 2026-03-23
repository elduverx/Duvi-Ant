import Foundation
import SwiftData

@Model
final class Budget {
    @Attribute(.unique) var id: UUID
    var limit: Double
    var period: BudgetPeriod
    var createdDate: Date

    @Relationship(deleteRule: .nullify)
    var category: Category?

    init(limit: Double, period: BudgetPeriod = .monthly, category: Category? = nil) {
        self.id = UUID()
        self.limit = limit
        self.period = period
        self.category = category
        self.createdDate = Date.now
    }

    enum BudgetPeriod: String, Codable {
        case weekly = "Semanal"
        case monthly = "Mensual"
        case yearly = "Anual"
    }

    func isExceeded(expenses: [Expense]) -> Bool {
        let calendar = Calendar.current
        let now = Date()

        let relevantExpenses = expenses.filter { expense in
            let withinPeriod: Bool
            switch period {
            case .weekly:
                let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
                let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
                withinPeriod = expense.date >= startOfWeek && expense.date < endOfWeek
            case .monthly:
                let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
                let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
                withinPeriod = expense.date >= startOfMonth && expense.date < endOfMonth
            case .yearly:
                let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: now))!
                let endOfYear = calendar.date(byAdding: .year, value: 1, to: startOfYear)!
                withinPeriod = expense.date >= startOfYear && expense.date < endOfYear
            }

            guard let cat = category else { return withinPeriod }
            return withinPeriod && expense.category?.name == cat.name
        }

        let total = relevantExpenses.reduce(0) { $0 + $1.amount }
        return total > limit
    }

    func percentageUsed(expenses: [Expense]) -> Double {
        let calendar = Calendar.current
        let now = Date()

        let relevantExpenses = expenses.filter { expense in
            let withinPeriod: Bool
            switch period {
            case .weekly:
                let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
                let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
                withinPeriod = expense.date >= startOfWeek && expense.date < endOfWeek
            case .monthly:
                let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
                let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
                withinPeriod = expense.date >= startOfMonth && expense.date < endOfMonth
            case .yearly:
                let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: now))!
                let endOfYear = calendar.date(byAdding: .year, value: 1, to: startOfYear)!
                withinPeriod = expense.date >= startOfYear && expense.date < endOfYear
            }

            guard let cat = category else { return withinPeriod }
            return withinPeriod && expense.category?.name == cat.name
        }

        let total = relevantExpenses.reduce(0) { $0 + $1.amount }
        return min((total / limit) * 100, 100)
    }
}
