import Foundation
import SwiftData

@Model
final class PushAlert {
    @Attribute(.unique) var id: UUID
    var title: String
    var message: String
    var type: AlertType
    var createdDate: Date
    var isRead: Bool

    init(title: String, message: String, type: AlertType) {
        self.id = UUID()
        self.title = title
        self.message = message
        self.type = type
        self.createdDate = Date.now
        self.isRead = false
    }

    enum AlertType: String, Codable {
        case budgetExceeded = "Presupuesto excedido"
        case savingsGoalProgress = "Progreso en meta"
        case unusualSpending = "Gasto inusual"
        case recurringExpense = "Gasto recurrente"
        case reminder = "Recordatorio"
    }
}
