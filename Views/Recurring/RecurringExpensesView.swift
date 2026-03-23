import SwiftUI

struct RecurringExpensesView: View {
    let viewModel: ExpenseViewModel
    @State private var showingAddRecurring = false

    var totalMonthly: Double {
        viewModel.recurringExpenses
            .filter { $0.isActive }
            .reduce(0) { total, recurring in
                let monthlyAmount: Double
                switch recurring.frequency {
                case .daily:
                    monthlyAmount = recurring.amount * 30
                case .weekly:
                    monthlyAmount = recurring.amount * 4.33
                case .biweekly:
                    monthlyAmount = recurring.amount * 2.17
                case .monthly:
                    monthlyAmount = recurring.amount
                case .quarterly:
                    monthlyAmount = recurring.amount / 3
                case .yearly:
                    monthlyAmount = recurring.amount / 12
                }
                return total + monthlyAmount
            }
    }

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.recurringExpenses.isEmpty {
                    ContentUnavailableView(
                        "Sin gastos recurrentes",
                        systemImage: "repeat.circle",
                        description: Text("Crea gastos automáticos para mantenerlos actualizados.")
                    )
                } else {
                    List {
                        Section {
                            HStack {
                                Text("Total mensual estimado")
                                    .font(.subheadline)

                                Spacer()

                                Text("$\(totalMonthly, specifier: "%.2f")")
                                    .font(.headline)
                                    .fontWeight(.bold)
                            }
                            .padding(.vertical, 4)
                        }

                        Section("Gastos Recurrentes") {
                            ForEach(viewModel.recurringExpenses) { recurring in
                                RecurringExpenseRow(recurring: recurring)
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive) {
                                            viewModel.deleteRecurringExpense(recurring)
                                        } label: {
                                            Label("Borrar", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Gastos Recurrentes")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddRecurring = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddRecurring) {
                AddRecurringSheet(viewModel: viewModel)
            }
        }
    }
}

struct RecurringExpenseRow: View {
    let recurring: RecurringExpense

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "arrow.3.trianglepath")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 40, height: 40)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                AppTheme.secondary.opacity(0.1),
                                AppTheme.primary.opacity(0.05)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(AppTheme.cornerMedium)
                    .foregroundColor(AppTheme.secondary)

                VStack(alignment: .leading, spacing: 3) {
                    Text(recurring.note.isEmpty ? "Gasto automático" : recurring.note)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)

                    HStack(spacing: 8) {
                        Label(recurring.frequency.rawValue, systemImage: "repeat")
                            .font(.caption2)
                            .foregroundColor(.secondary)

                        Text("•")
                            .foregroundColor(.secondary)

                        Text("Próx: \(recurring.nextOccurrence.formatted(date: .abbreviated, time: .omitted))")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("$\(recurring.amount, specifier: "%.2f")")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(AppTheme.secondary)

                    if recurring.isActive {
                        Label("Activo", systemImage: "checkmark.circle.fill")
                            .font(.caption2)
                            .foregroundColor(AppTheme.success)
                    } else {
                        Label("Pausado", systemImage: "pause.circle.fill")
                            .font(.caption2)
                            .foregroundColor(AppTheme.accent)
                    }
                }
            }
        }
        .padding(12)
        .background(AppTheme.secondaryBackground)
        .cornerRadius(AppTheme.cornerMedium)
    }
}
