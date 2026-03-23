import Foundation
import SwiftData

@Model
final class Category {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String = ""
    var icon: String = "tag.fill"  // SF Symbol
    
    @Relationship(deleteRule: .cascade, inverse: \Expense.category)
    var expenses: [Expense] = []
    
    init(name: String, icon: String) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.expenses = []
    }
}
