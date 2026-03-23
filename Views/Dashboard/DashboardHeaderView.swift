import SwiftUI

struct DashboardHeaderView: View {
    let amount: Double
    var budgetExceeded: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Label("Gastos del mes", systemImage: "calendar.badge.clock")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.secondary)

                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text("$")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(AppTheme.primary)

                        Text("\(amount, specifier: "%.0f")")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                    }
                }

                Spacer()

                VStack(alignment: .center, spacing: 8) {
                    Image(systemName: budgetExceeded ? "exclamationmark.circle.fill" : "checkmark.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(budgetExceeded ? AppTheme.danger : AppTheme.success)

                    Text(budgetExceeded ? "Alerta" : "Normal")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                }
            }

            Divider()
                .opacity(0.1)

            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Label("Este mes", systemImage: "calendar")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("En progreso")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.primary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Label(Int(amount / 30) > 0 ? "\(Int(amount / 30))/día" : "$0/día", systemImage: "chart.bar.xaxis")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Promedio")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.primary)
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            ZStack {
                AppTheme.secondaryBackground
                
                LinearGradient(
                    gradient: Gradient(colors: [
                        AppTheme.primary.opacity(0.08),
                        AppTheme.secondary.opacity(0.04)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        )
        .cornerRadius(AppTheme.cornerLarge)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cornerLarge)
                .stroke(AppTheme.primary.opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}
