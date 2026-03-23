import Foundation
import SwiftData

@Model
final class RecurringExpense {
    @Attribute(.unique) var id: UUID
    var amount: Double
    var note: String
    var frequency: Frequency
    var nextOccurrence: Date
    var lastCreated: Date?
    var isActive: Bool

    @Relationship(deleteRule: .nullify)
    var category: Category?

    init(amount: Double, note: String, frequency: Frequency, nextOccurrence: Date, category: Category? = nil) {
        self.id = UUID()
        self.amount = amount
        self.note = note
        self.frequency = frequency
        self.nextOccurrence = nextOccurrence
        self.isActive = true
        self.category = category
        self.lastCreated = nil
    }

    enum Frequency: String, Codable {
        case daily = "Diario"
        case weekly = "Semanal"
        case biweekly = "Cada 2 semanas"
        case monthly = "Mensual"
        case quarterly = "Trimestral"
        case yearly = "Anual"

        func nextDate(from date: Date) -> Date {
            let calendar = Calendar.current
            let component: Calendar.Component
            let value: Int

            switch self {
            case .daily:
                component = .day
                value = 1
            case .weekly:
                component = .day
                value = 7
            case .biweekly:
                component = .day
                value = 14
            case .monthly:
                component = .month
                value = 1
            case .quarterly:
                component = .month
                value = 3
            case .yearly:
                component = .year
                value = 1
            }

            return calendar.date(byAdding: component, value: value, to: date) ?? date
        }
    }

    func shouldCreateExpense() -> Bool {
        return isActive && nextOccurrence <= Date()
    }
}
