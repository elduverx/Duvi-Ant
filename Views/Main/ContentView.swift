import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: ExpenseViewModel?
    @State private var showingAddSheet = false
    @State private var selectedExpenseForEdit: Expense?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.spacing.xl) {
                    if let vm = viewModel {
                        // 1. Wallet Cards Carousel
                        WalletCarouselView(accounts: vm.bankAccounts) {
                            Task {
                                await vm.syncWithFinanceKit()
                            }
                        }
                        .padding(.top)

                        // 2. Summary & Filters Container
                        VStack(spacing: AppTheme.spacing.lg) {
                            DashboardHeaderView(amount: vm.totalMonthExpenses)
                            
                            // Search Bar
                            let searchText = Binding<String>(
                                get: { vm.searchText },
                                set: { vm.searchText = $0 }
                            )
                            SearchBar(text: searchText)
                                .padding(.horizontal)

                            // Category Filter
                            categoryFilterRow(vm: vm)

                            // Date Range Filter
                            dateRangeRow(vm: vm)
                        }
                        .padding(.vertical, AppTheme.spacing.md)
                        .background(AppTheme.secondaryBackground.opacity(0.8))
                        .cornerRadius(AppTheme.cornerXXL)
                        .padding(.horizontal)

                        // 5. Activity List
                        VStack(alignment: .leading, spacing: AppTheme.spacing.md) {
                            Text("Actividad reciente")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            if combinedActivity(vm: vm).isEmpty {
                                ContentUnavailableView(
                                    "Sin actividad",
                                    systemImage: "ant.fill",
                                    description: Text("No hay gastos o transacciones aquí.")
                                )
                                .frame(height: 200)
                            } else {
                                LazyVStack(spacing: AppTheme.spacing.md) {
                                    ForEach(combinedActivity(vm: vm), id: \.id) { item in
                                        if let expense = item as? Expense {
                                            expenseRow(expense)
                                                .onTapGesture {
                                                    selectedExpenseForEdit = expense
                                                }
                                        } else if let transaction = item as? BankTransaction {
                                            bankTransactionRow(transaction)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    } else {
                        ProgressView("Preparando hormiguero...")
                            .onAppear {
                                viewModel = ExpenseViewModel(modelContext: modelContext)
                            }
                    }
                }
                .padding(.bottom, 100)
            }
            .navigationTitle("Duvi Ant")
            .background(AppTheme.background)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(AppTheme.primary)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                if let vm = viewModel {
                    AddExpenseSheet(viewModel: vm)
                }
            }
            .sheet(item: $selectedExpenseForEdit) { expense in
                if let vm = viewModel {
                    EditExpenseSheet(viewModel: vm, expense: expense)
                }
            }
        }
    }
    
    // Helper to combine and sort activity
    private func combinedActivity(vm: ExpenseViewModel) -> [ActivityItem] {
        let expenses = vm.filteredExpenses
        let transactions = vm.bankTransactions.prefix(20) // Limit to recent
        
        var combined: [ActivityItem] = Array(expenses)
        combined.append(contentsOf: Array(transactions))
        
        return combined.sorted { $0.date > $1.date }
    }

    @ViewBuilder
    private func bankTransactionRow(_ transaction: BankTransaction) -> some View {
        HStack(spacing: 12) {
            // Icon from category or generic creditcard
            ZStack {
                RoundedRectangle(cornerRadius: AppTheme.cornerMedium)
                    .fill(AppTheme.primary.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: transaction.category?.icon ?? "creditcard.fill")
                    .foregroundColor(AppTheme.primary)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(transaction.merchantName ?? transaction.transactionDescription)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)

                HStack(spacing: 8) {
                    Text(transaction.notes ?? (transaction.account?.institutionName ?? "Banco"))
                        .font(.caption2)
                        .foregroundColor(.secondary)

                    Text("•")
                        .foregroundColor(.secondary)

                    Text(transaction.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Text("\(transaction.isIncome ? "" : "-")$\(abs(transaction.amount), specifier: "%.2f")")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(transaction.isIncome ? AppTheme.success : .primary)
        }
        .padding(12)
        .background(AppTheme.secondaryBackground)
        .cornerRadius(AppTheme.cornerMedium)
    }
    
    // View Components
    @ViewBuilder
    private func dateRangeRow(vm: ExpenseViewModel) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                Button {
                    vm.selectedDateRange = .allTime
                } label: {
                    Text("Todo")
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(isDateRangeSelected(.allTime, vm) ? AppTheme.primary : AppTheme.tertiaryBackground)
                        .foregroundColor(isDateRangeSelected(.allTime, vm) ? .white : .primary)
                        .clipShape(Capsule())
                }

                Button {
                    vm.selectedDateRange = .today
                } label: {
                    Text("Hoy")
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(isDateRangeSelected(.today, vm) ? AppTheme.primary : AppTheme.tertiaryBackground)
                        .foregroundColor(isDateRangeSelected(.today, vm) ? .white : .primary)
                        .clipShape(Capsule())
                }

                Button {
                    vm.selectedDateRange = .week
                } label: {
                    Text("Semana")
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(isDateRangeSelected(.week, vm) ? AppTheme.primary : AppTheme.tertiaryBackground)
                        .foregroundColor(isDateRangeSelected(.week, vm) ? .white : .primary)
                        .clipShape(Capsule())
                }

                Button {
                    vm.selectedDateRange = .month
                } label: {
                    Text("Mes")
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(isDateRangeSelected(.month, vm) ? AppTheme.primary : AppTheme.tertiaryBackground)
                        .foregroundColor(isDateRangeSelected(.month, vm) ? .white : .primary)
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal)
        }
    }

    private func isDateRangeSelected(_ range: ExpenseViewModel.DateRange, _ vm: ExpenseViewModel) -> Bool {
        switch (range, vm.selectedDateRange) {
        case (.allTime, .allTime), (.today, .today), (.week, .week), (.month, .month):
            return true
        default:
            return false
        }
    }

    @ViewBuilder
    private func categoryFilterRow(vm: ExpenseViewModel) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                Button {
                    vm.selectedCategoryFilter = nil
                } label: {
                    Text("Todos")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(vm.selectedCategoryFilter == nil ? AppTheme.primary : AppTheme.tertiaryBackground)
                        .foregroundColor(vm.selectedCategoryFilter == nil ? .white : .primary)
                        .clipShape(Capsule())
                }
                
                ForEach(vm.categories) { category in
                    Button {
                        vm.selectedCategoryFilter = category
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: category.icon)
                                .font(.system(size: 13, weight: .semibold))
                            Text(category.name)
                                .font(.system(size: 13, weight: .medium))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            vm.selectedCategoryFilter?.id == category.id ?
                            AppTheme.primary : AppTheme.tertiaryBackground
                        )
                        .foregroundColor(vm.selectedCategoryFilter?.id == category.id ? .white : .primary)
                        .cornerRadius(AppTheme.cornerSmall)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private func expenseRow(_ expense: Expense) -> some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: AppTheme.cornerMedium)
                    .fill(AppTheme.primary.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: expense.category?.icon ?? "tag.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppTheme.primary)
            }

            // Content
            VStack(alignment: .leading, spacing: 3) {
                Text(expense.note.isEmpty ? "Sin descripción" : expense.note)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)

                HStack(spacing: 8) {
                    Label(expense.category?.name ?? "Otros", systemImage: "tag")
                        .font(.caption2)
                        .foregroundColor(.secondary)

                    Text("•")
                        .foregroundColor(.secondary)

                    Text(expense.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            // Amount
            Text("$\(expense.amount, specifier: "%.2f")")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(AppTheme.primary)
        }
        .padding(12)
        .background(AppTheme.secondaryBackground)
        .cornerRadius(AppTheme.cornerMedium)
    }
}
