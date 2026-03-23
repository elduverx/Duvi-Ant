import SwiftUI

struct AddRecurringSheet: View {
    @Environment(\.dismiss) private var dismiss
    let viewModel: ExpenseViewModel

    @State private var amount: String = ""
    @State private var note: String = ""
    @State private var selectedFrequency: RecurringExpense.Frequency = .monthly
    @State private var selectedCategory: Category?

    var body: some View {
        NavigationStack {
            Form {
                Section("Monto") {
                    HStack {
                        Text("$")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                        TextField("0.00", text: $amount)
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .keyboardType(.decimalPad)
                    }
                    .padding(.vertical, 8)
                }

                Section("Descripción") {
                    TextField("ej: Netflix, Spotify...", text: $note)
                }

                Section("Frecuencia") {
                    Picker("Repetir cada", selection: $selectedFrequency) {
                        Text(RecurringExpense.Frequency.daily.rawValue).tag(RecurringExpense.Frequency.daily)
                        Text(RecurringExpense.Frequency.weekly.rawValue).tag(RecurringExpense.Frequency.weekly)
                        Text(RecurringExpense.Frequency.biweekly.rawValue).tag(RecurringExpense.Frequency.biweekly)
                        Text(RecurringExpense.Frequency.monthly.rawValue).tag(RecurringExpense.Frequency.monthly)
                        Text(RecurringExpense.Frequency.quarterly.rawValue).tag(RecurringExpense.Frequency.quarterly)
                        Text(RecurringExpense.Frequency.yearly.rawValue).tag(RecurringExpense.Frequency.yearly)
                    }
                }

                Section("Categoría") {
                    HStack(spacing: 8) {
                        ForEach(Array(viewModel.categories.prefix(5)), id: \.id) { category in
                            categoryButton(for: category)
                        }
                    }
                    .padding(.vertical, 4)

                    if viewModel.categories.count > 5 {
                        HStack(spacing: 8) {
                            ForEach(Array(viewModel.categories.dropFirst(5)), id: \.id) { category in
                                categoryButton(for: category)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("Próxima ocurrencia") {
                    Text(Date().formatted(date: .abbreviated, time: .omitted))
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Nuevo Gasto Recurrente")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        if let amountDouble = Double(amount.replacingOccurrences(of: ",", with: ".")) {
                            viewModel.addRecurringExpense(
                                amount: amountDouble,
                                note: note,
                                frequency: selectedFrequency,
                                nextOccurrence: Date(),
                                category: selectedCategory
                            )
                            dismiss()
                        }
                    }
                    .disabled(amount.isEmpty || Double(amount.replacingOccurrences(of: ",", with: ".")) == nil)
                    .fontWeight(.bold)
                }
            }
            .onAppear {
                if selectedCategory == nil {
                    selectedCategory = viewModel.categories.first
                }
            }
        }
    }

    private func categoryButton(for category: Category) -> some View {
        Button {
            selectedCategory = category
        } label: {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 22, weight: .semibold))
                    .frame(height: 40)

                Text(category.name)
                    .font(.caption2)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(8)
            .background(
                selectedCategory?.id == category.id ?
                LinearGradient(
                    gradient: Gradient(colors: [
                        AppTheme.primary.opacity(0.15),
                        AppTheme.secondary.opacity(0.08)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ) :
                LinearGradient(
                    gradient: Gradient(colors: [
                        AppTheme.secondaryBackground,
                        AppTheme.background
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(AppTheme.cornerMedium)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerMedium)
                    .stroke(
                        selectedCategory?.id == category.id ?
                        AppTheme.primary.opacity(0.3) :
                        Color.clear,
                        lineWidth: 2
                    )
            )
            .foregroundColor(
                selectedCategory?.id == category.id ?
                AppTheme.primary :
                .primary
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
