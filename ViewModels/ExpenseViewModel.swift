import Foundation
import SwiftData
import SwiftUI

@Observable
@MainActor
final class ExpenseViewModel {
    private var modelContext: ModelContext
    private var financeManager: FinanceKitManager
    
    var expenses: [Expense] = []
    var bankAccounts: [BankAccount] = []
    var bankTransactions: [BankTransaction] = []
    var categories: [Category] = []
    var budgets: [Budget] = []
    var recurringExpenses: [RecurringExpense] = []
    var savingsGoals: [SavingsGoal] = []
    var alerts: [PushAlert] = []
    
    var isSyncing: Bool { financeManager.isSyncing }

    // Filtros
    var selectedCategoryFilter: Category? = nil
    var searchText: String = ""
    var selectedDateRange: DateRange = .allTime

    enum DateRange {
        case allTime
        case today
        case week
        case month
        case custom(start: Date, end: Date)

        var description: String {
            switch self {
            case .allTime: return "Todo el tiempo"
            case .today: return "Hoy"
            case .week: return "Esta semana"
            case .month: return "Este mes"
            case .custom: return "Personalizado"
            }
        }
    }
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.financeManager = FinanceKitManager(modelContext: modelContext)
        fetchData()
        seedInitialCategories()
    }
    
    func fetchData() {
        do {
            let expenseDescriptor = FetchDescriptor<Expense>(
                sortBy: [SortDescriptor(\.date, order: .reverse)]
            )
            self.expenses = try modelContext.fetch(expenseDescriptor)

            let accountDescriptor = FetchDescriptor<BankAccount>(
                sortBy: [SortDescriptor(\.institutionName)]
            )
            self.bankAccounts = try modelContext.fetch(accountDescriptor)

            let transactionDescriptor = FetchDescriptor<BankTransaction>(
                sortBy: [SortDescriptor(\.date, order: .reverse)]
            )
            self.bankTransactions = try modelContext.fetch(transactionDescriptor)

            let categoryDescriptor = FetchDescriptor<Category>(
                sortBy: [SortDescriptor(\.name)]
            )
            self.categories = try modelContext.fetch(categoryDescriptor)

            let budgetDescriptor = FetchDescriptor<Budget>(
                sortBy: [SortDescriptor(\.createdDate, order: .reverse)]
            )
            self.budgets = try modelContext.fetch(budgetDescriptor)

            let recurringDescriptor = FetchDescriptor<RecurringExpense>(
                sortBy: [SortDescriptor(\.nextOccurrence)]
            )
            self.recurringExpenses = try modelContext.fetch(recurringDescriptor)

            let goalsDescriptor = FetchDescriptor<SavingsGoal>(
                sortBy: [SortDescriptor(\.deadline)]
            )
            self.savingsGoals = try modelContext.fetch(goalsDescriptor)

            let alertsDescriptor = FetchDescriptor<PushAlert>(
                sortBy: [SortDescriptor(\.createdDate, order: .reverse)]
            )
            self.alerts = try modelContext.fetch(alertsDescriptor)
        } catch {
            print("Error al cargar datos: \(error.localizedDescription)")
        }
    }
    
    func syncWithFinanceKit() async {
        await financeManager.performFullSync()
        fetchData()
    }
    
    func addExpense(amount: Double, note: String, category: Category?) {
        let newExpense = Expense(amount: amount, note: note, category: category)
        modelContext.insert(newExpense)
        save()
        fetchData()
    }
    
    func updateExpense(_ expense: Expense, amount: Double, note: String, category: Category?) {
        expense.amount = amount
        expense.note = note
        expense.category = category
        save()
        fetchData()
    }

    func deleteExpense(_ expense: Expense) {
        modelContext.delete(expense)
        save()
        fetchData()
    }

    func addBudget(limit: Double, period: Budget.BudgetPeriod, category: Category?) {
        let newBudget = Budget(limit: limit, period: period, category: category)
        modelContext.insert(newBudget)
        save()
        fetchData()
    }

    func deleteBudget(_ budget: Budget) {
        modelContext.delete(budget)
        save()
        fetchData()
    }

    func addGoal(name: String, targetAmount: Double, deadline: Date, emoji: String) {
        let goal = SavingsGoal(name: name, targetAmount: targetAmount, deadline: deadline, emoji: emoji)
        modelContext.insert(goal)
        save()
        fetchData()
    }

    func deleteGoal(_ goal: SavingsGoal) {
        modelContext.delete(goal)
        save()
        fetchData()
    }

    func updateGoalProgress(_ goal: SavingsGoal, amount: Double) {
        goal.currentAmount = amount
        save()
        fetchData()
    }

    func addRecurringExpense(amount: Double, note: String, frequency: RecurringExpense.Frequency, nextOccurrence: Date, category: Category?) {
        let recurring = RecurringExpense(amount: amount, note: note, frequency: frequency, nextOccurrence: nextOccurrence, category: category)
        modelContext.insert(recurring)
        save()
        fetchData()
    }

    func deleteRecurringExpense(_ recurring: RecurringExpense) {
        modelContext.delete(recurring)
        save()
        fetchData()
    }

    func processRecurringExpenses() {
        for recurring in recurringExpenses where recurring.shouldCreateExpense() {
            let expense = Expense(amount: recurring.amount, note: recurring.note, category: recurring.category)
            modelContext.insert(expense)
            recurring.nextOccurrence = recurring.frequency.nextDate(from: recurring.nextOccurrence)
            recurring.lastCreated = Date()
        }
        save()
        fetchData()
    }
    
    private func save() {
        do {
            try modelContext.save()
        } catch {
            print("Error al guardar: \(error.localizedDescription)")
        }
    }
    
    private func seedInitialCategories() {
        let descriptor = FetchDescriptor<Category>()
        let count = (try? modelContext.fetchCount(descriptor)) ?? 0
        
        if count == 0 {
            let defaults = [
                Category(name: "Alimentación", icon: "cup.and.saucer.fill"),
                Category(name: "Transporte", icon: "car.fill"),
                Category(name: "Entretenimiento", icon: "film.fill"),
                Category(name: "Suscripciones", icon: "app.badge.fill"),
                Category(name: "Otros", icon: "ellipsis.circle.fill")
            ]
            
            for cat in defaults {
                modelContext.insert(cat)
            }
            save()
            fetchData()
        }
    }
    
    // Business Logic
    var totalMonthExpenses: Double {
        let now = Date()
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: now)
        let currentYear = calendar.component(.year, from: now)
        
        return expenses.filter {
            let expMonth = calendar.component(.month, from: $0.date)
            let expYear = calendar.component(.year, from: $0.date)
            return expMonth == currentMonth && expYear == currentYear
        }.reduce(0) { $0 + $1.amount }
    }
    
    var filteredExpenses: [Expense] {
        var result = expenses

        // Category filter
        if let filter = selectedCategoryFilter {
            result = result.filter { $0.category?.id == filter.id }
        }

        // Date range filter
        result = filterByDateRange(result)

        // Search filter
        if !searchText.isEmpty {
            result = result.filter { expense in
                expense.note.localizedCaseInsensitiveContains(searchText) ||
                expense.category?.name.localizedCaseInsensitiveContains(searchText) ?? false
            }
        }

        return result
    }

    // MARK: - Advanced Filtering

    private func filterByDateRange(_ expenses: [Expense]) -> [Expense] {
        let calendar = Calendar.current
        let now = Date()

        switch selectedDateRange {
        case .allTime:
            return expenses

        case .today:
            let startOfDay = calendar.startOfDay(for: now)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            return expenses.filter { $0.date >= startOfDay && $0.date < endOfDay }

        case .week:
            let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
            let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
            return expenses.filter { $0.date >= startOfWeek && $0.date < endOfWeek }

        case .month:
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
            let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
            return expenses.filter { $0.date >= startOfMonth && $0.date < endOfMonth }

        case .custom(let start, let end):
            return expenses.filter { $0.date >= start && $0.date <= end }
        }
    }

    // MARK: - Statistics

    func expensesForCategory(_ category: Category) -> Double {
        expenses.filter { $0.category?.id == category.id }.reduce(0) { $0 + $1.amount }
    }

    func topCategories(limit: Int = 5) -> [(categoryName: String, total: Double)] {
        Dictionary(grouping: expenses, by: { $0.category?.name ?? "Sin categoría" })
            .map { name, expenses in
                let total = expenses.reduce(0) { $0 + $1.amount }
                return (categoryName: name, total: total)
            }
            .sorted { $0.total > $1.total }
            .prefix(limit)
            .map { $0 }
    }

    func averageExpenseAmount() -> Double {
        guard !expenses.isEmpty else { return 0 }
        return totalMonthExpenses / Double(expenses.count)
    }

    // MARK: - Export

    func exportToCSV() -> String {
        var csv = "Fecha,Monto,Categoría,Nota\n"

        for expense in filteredExpenses.sorted(by: { $0.date > $1.date }) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            let date = dateFormatter.string(from: expense.date)
            let amount = String(format: "%.2f", expense.amount)
            let category = expense.category?.name ?? "Sin categoría"
            let note = expense.note.replacingOccurrences(of: "\"", with: "\"\"")

            csv += "\"\(date)\",\"\(amount)\",\"\(category)\",\"\(note)\"\n"
        }

        return csv
    }

    func shareCSV() -> URL? {
        let csv = exportToCSV()
        let fileName = "DuviAnt_\(Date().formatted(date: .abbreviated, time: .omitted)).csv"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        do {
            try csv.write(to: url, atomically: true, encoding: .utf8)
            return url
        } catch {
            print("Error al exportar CSV: \(error)")
            return nil
        }
    }
}
