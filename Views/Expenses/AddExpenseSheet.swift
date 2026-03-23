import SwiftUI

struct AddExpenseSheet: View {
    @Environment(\.dismiss) private var dismiss
    let viewModel: ExpenseViewModel
    
    @State private var amount: String = ""
    @State private var note: String = ""
    @State private var selectedCategory: Category?
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("$")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.textSecondary)
                        TextField("0.00", text: $amount)
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .keyboardType(.decimalPad)
                            .foregroundColor(AppTheme.text)
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("¿Cuánto fue?")
                }
                
                Section {
                    TextField("Café, Chicles, Donas...", text: $note)
                        .foregroundColor(AppTheme.text)
                } header: {
                    Text("Descripción")
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
            }
            .navigationTitle("Nuevo Gasto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        if let amountDouble = Double(amount.replacingOccurrences(of: ",", with: ".")) {
                            viewModel.addExpense(amount: amountDouble, note: note, category: selectedCategory)
                            dismiss()
                        }
                    }
                    .disabled(amount.isEmpty || Double(amount.replacingOccurrences(of: ",", with: ".")) == nil)
                    .fontWeight(.bold)
                    .tint(AppTheme.primary)
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
                        AppTheme.tertiaryBackground,
                        AppTheme.tertiaryBackground.opacity(0.8)
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
                AppTheme.text
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
