import Foundation
import SwiftData

@Model
final class SavingsGoal {
    @Attribute(.unique) var id: UUID
    var name: String
    var targetAmount: Double
    var currentAmount: Double
    var deadline: Date
    var emoji: String
    var createdDate: Date

    init(name: String, targetAmount: Double, deadline: Date, emoji: String = "target") {
        self.id = UUID()
        self.name = name
        self.targetAmount = targetAmount
        self.currentAmount = 0.0
        self.deadline = deadline
        self.emoji = emoji
        self.createdDate = Date.now
    }

    var progress: Double {
        min((currentAmount / targetAmount) * 100, 100)
    }

    var isCompleted: Bool {
        currentAmount >= targetAmount
    }

    var remainingAmount: Double {
        max(targetAmount - currentAmount, 0)
    }

    var daysRemaining: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: deadline)
        return max(components.day ?? 0, 0)
    }

    var isOverdue: Bool {
        !isCompleted && Date() > deadline
    }
}
