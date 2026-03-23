import SwiftUI

struct AddGoalSheet: View {
    @Environment(\.dismiss) private var dismiss
    let viewModel: ExpenseViewModel

    @State private var goalName: String = ""
    @State private var targetAmount: String = ""
    @State private var selectedEmoji: String = "target"
    @State private var selectedDate: Date = Date().addingTimeInterval(30 * 24 * 3600) // 30 días

    let emojiOptions = ["target", "house.fill", "airplane", "book.fill", "heart.fill", "car.fill", "iphone", "gamecontroller.fill", "sun.max.fill", "banknote.fill"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Nombre de la Meta") {
                    TextField("ej: Viaje a París", text: $goalName)
                }

                Section("Icono") {
                    firstRowIcons
                    if emojiOptions.count > 5 {
                        secondRowIcons
                    }
                }

                Section("Monto Meta") {
                    HStack {
                        Text("$")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                        TextField("0.00", text: $targetAmount)
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .keyboardType(.decimalPad)
                    }
                    .padding(.vertical, 8)
                }

                Section("Fecha Límite") {
                    DatePicker(
                        "Conseguir antes de",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                }
            }
            .navigationTitle("Nueva Meta")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Crear") {
                        if let amount = Double(targetAmount.replacingOccurrences(of: ",", with: ".")) {
                            viewModel.addGoal(
                                name: goalName.isEmpty ? "Meta sin nombre" : goalName,
                                targetAmount: amount,
                                deadline: selectedDate,
                                emoji: selectedEmoji
                            )
                            dismiss()
                        }
                    }
                    .disabled(targetAmount.isEmpty || Double(targetAmount.replacingOccurrences(of: ",", with: ".")) == nil)
                    .fontWeight(.bold)
                }
            }
        }
    }

    private var firstRowIcons: some View {
        HStack(spacing: 12) {
            ForEach(Array(emojiOptions.prefix(5)), id: \.self) { symbolName in
                iconButtonView(symbolName)
            }
        }
    }

    private var secondRowIcons: some View {
        HStack(spacing: 12) {
            ForEach(Array(emojiOptions.dropFirst(5)), id: \.self) { symbolName in
                iconButtonView(symbolName)
            }
        }
    }

    private func iconButtonView(_ symbolName: String) -> some View {
        Button {
            selectedEmoji = symbolName
        } label: {
            VStack(spacing: 6) {
                Image(systemName: symbolName)
                    .font(.system(size: 24, weight: .semibold))
                    .frame(height: 40)
                Text(symbolName.replacingOccurrences(of: ".fill", with: ""))
                    .font(.caption2)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(8)
            .background(
                selectedEmoji == symbolName ?
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
                        selectedEmoji == symbolName ?
                        AppTheme.primary.opacity(0.3) :
                        Color.clear,
                        lineWidth: 2
                    )
            )
            .foregroundColor(
                selectedEmoji == symbolName ?
                AppTheme.primary :
                .primary
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
