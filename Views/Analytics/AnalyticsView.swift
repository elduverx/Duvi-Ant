import SwiftUI
import Charts

struct AnalyticsView: View {
    let viewModel: ExpenseViewModel
    @State private var animateInsights = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Score Card - Estilo Fitness+ con anillo
                    spendingScoreCard

                    // Insights Cards
                    insightsGrid

                    // Prediction & Trends
                    predictionCard

                    // Category Breakdown con mini chart
                    categoryBreakdownCard

                    // Smart Recommendations
                    recommendationsCard
                }
                .padding()
            }
            .background(AppTheme.background)
            .navigationTitle("Análisis")
            .onAppear {
                withAnimation(.easeInOut(duration: 0.8)) {
                    animateInsights = true
                }
            }
        }
    }

    // MARK: - Spending Score (Ring Chart - Fitness+ Style)

    private var spendingScoreCard: some View {
        let score = calculateSpendingScore()
        let scoreColor = scoreColor(score)

        return VStack(spacing: 20) {
            Text("Score de Gastos")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white.opacity(0.9))

            ZStack {
                // Background ring
                Circle()
                    .stroke(Color.white.opacity(0.2), lineWidth: 16)
                    .frame(width: 160, height: 160)

                // Progress ring
                Circle()
                    .trim(from: 0, to: animateInsights ? (score / 100) : 0)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                scoreColor.opacity(0.7),
                                scoreColor
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 16, lineCap: .round)
                    )
                    .frame(width: 160, height: 160)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.2), value: animateInsights)

                VStack(spacing: 4) {
                    Text("\(Int(score))")
                        .font(.system(size: 60, weight: .black, design: .rounded))
                        .foregroundColor(.white)

                    Text(scoreLabel(score))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.8))
                }
            }

            Text("Basado en tus hábitos de gasto y objetivos")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 32)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    scoreColor,
                    scoreColor.opacity(0.8)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(AppTheme.cornerXL)
        .shadow(color: scoreColor.opacity(0.4), radius: 15, x: 0, y: 8)
    }

    // MARK: - Insights Grid

    private var insightsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            // Daily Average
            insightCard(
                title: "Promedio Diario",
                value: "$\(Int(dailyAverage))",
                icon: "calendar",
                color: AppTheme.primary
            )

            // Top Category
            insightCard(
                title: "Más Gastado",
                value: topCategoryName,
                icon: "chart.pie.fill",
                color: AppTheme.success
            )

            // Week vs Month
            insightCard(
                title: "Tendencia",
                value: "\(Int(weekPercentage))%",
                icon: trendIcon,
                color: AppTheme.accent
            )

            // Total Count
            insightCard(
                title: "Total Gastos",
                value: "\(viewModel.expenses.count)",
                icon: "list.bullet",
                color: .purple
            )
        }
    }

    private func insightCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(color)

                Spacer()
            }

            Spacer()

            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.primary)

            Text(title)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(.secondary)
            }
            .padding(AppTheme.spacing.lg)
            .frame(height: 120)
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerLarge)
            .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
            }
    // MARK: - Prediction Card

    private var predictionCard: some View {
        let dayOfMonth = Calendar.current.component(.day, from: Date())
        let daysInMonth = Calendar.current.range(of: .day, in: .month, for: Date())?.count ?? 30
        let currentDaily = viewModel.totalMonthExpenses / Double(dayOfMonth)
        let projectedTotal = currentDaily * Double(daysInMonth)
        let difference = projectedTotal - viewModel.totalMonthExpenses

        return VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Proyección del Mes")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Text("Basado en tu ritmo actual")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(AppTheme.primary)
            }

            Divider()

            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Proyectado")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)

                    Text("$\(Int(projectedTotal))")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(AppTheme.primary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 8) {
                    Text("Restante")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)

                    Text("$\(Int(difference))")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(AppTheme.accent)
                }
            }

            // Mini progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)

                    Capsule()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    AppTheme.primary,
                                    AppTheme.secondary
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: animateInsights ? geometry.size.width * CGFloat(min(projectedTotal > 0 ? viewModel.totalMonthExpenses / projectedTotal : 0, 1.0)) : 0, height: 8)
                        .animation(.easeInOut(duration: 1.0), value: animateInsights)
                }
            }
            .frame(height: 8)

            Text("\(projectedTotal > 0 ? Int((viewModel.totalMonthExpenses / projectedTotal) * 100) : 0)% del mes completado")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(24)
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cornerXL)
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
    }

    // MARK: - Category Breakdown (Mini Chart)

    private var categoryBreakdownCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Top Categorías")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            ForEach(topCategories.prefix(5), id: \.name) { category in
                categoryRow(category: category)
            }
        }
        .padding(24)
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cornerXL)
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
    }

    private func categoryRow(category: (name: String, icon: String, total: Double)) -> some View {
        let percentage = viewModel.totalMonthExpenses > 0 ? (category.total / viewModel.totalMonthExpenses) : 0

        return VStack(spacing: 8) {
            HStack(spacing: 12) {
                Image(systemName: category.icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppTheme.primary)
                    .frame(width: 24, height: 24)

                Text(category.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)

                Spacer()

                Text("$\(Int(category.total))")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 6)

                    Capsule()
                        .fill(AppTheme.primary)
                        .frame(width: animateInsights ? geometry.size.width * CGFloat(percentage) : 0, height: 6)
                        .animation(.easeInOut(duration: 0.8).delay(0.1), value: animateInsights)
                }
            }
            .frame(height: 6)
        }
    }

    // MARK: - Recommendations

    private var recommendationsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.yellow)

                Text("Recomendaciones")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }

            VStack(alignment: .leading, spacing: 12) {
                if viewModel.totalMonthExpenses > 1500 {
                    recommendationRow(
                        icon: "exclamationmark.triangle.fill",
                        text: "Tus gastos están por encima del promedio",
                        color: AppTheme.accent
                    )
                }

                if viewModel.budgets.isEmpty {
                    recommendationRow(
                        icon: "target",
                        text: "Establece presupuestos para mejor control",
                        color: AppTheme.success
                    )
                }

                if viewModel.savingsGoals.isEmpty {
                    recommendationRow(
                        icon: "dollarsign.circle.fill",
                        text: "Crea metas de ahorro para alcanzar objetivos",
                        color: AppTheme.primary
                    )
                }

                if viewModel.recurringExpenses.isEmpty {
                    recommendationRow(
                        icon: "repeat.circle.fill",
                        text: "Registra gastos recurrentes para proyecciones precisas",
                        color: .purple
                    )
                }

                if dailyAverage > 50 {
                    recommendationRow(
                        icon: "chart.bar.fill",
                        text: "Intenta reducir gastos hormiga diarios",
                        color: AppTheme.danger
                    )
                }
            }
        }
        .padding(24)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    AppTheme.accent.opacity(0.1),
                    AppTheme.cardBackground
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(AppTheme.cornerXL)
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
    }

    private func recommendationRow(icon: String, text: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 32, height: 32)
                .background(color.opacity(0.15))
                .cornerRadius(AppTheme.cornerSmall)

            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)

            Spacer()
        }
        .padding(12)
        .background(AppTheme.secondaryBackground)
        .cornerRadius(AppTheme.cornerMedium)
    }

    // MARK: - Computed Properties

    private var dailyAverage: Double {
        let dayOfMonth = Calendar.current.component(.day, from: Date())
        return viewModel.totalMonthExpenses / Double(dayOfMonth)
    }

    private var topCategories: [(name: String, icon: String, total: Double)] {
        var categoryTotals: [String: (icon: String, total: Double)] = [:]

        for expense in viewModel.expenses {
            let categoryName = expense.category?.name ?? "Otros"
            let categoryIcon = expense.category?.icon ?? "questionmark.circle"

            if let existing = categoryTotals[categoryName] {
                categoryTotals[categoryName] = (icon: categoryIcon, total: existing.total + expense.amount)
            } else {
                categoryTotals[categoryName] = (icon: categoryIcon, total: expense.amount)
            }
        }

        return categoryTotals.map { (name: $0.key, icon: $0.value.icon, total: $0.value.total) }
            .sorted { $0.total > $1.total }
    }

    private var topCategoryName: String {
        topCategories.first?.name ?? "N/A"
    }

    private var weekPercentage: Double {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        let weekExpenses = viewModel.expenses.filter { $0.date >= weekAgo }.reduce(0) { $0 + $1.amount }
        return viewModel.totalMonthExpenses > 0 ? (weekExpenses / viewModel.totalMonthExpenses) * 100 : 0
    }

    private var trendIcon: String {
        weekPercentage > 50 ? "arrow.up.right.circle.fill" : "arrow.down.right.circle.fill"
    }

    // MARK: - Helper Methods

    private func calculateSpendingScore() -> Double {
        var score = 100.0

        // Penalize high spending
        if viewModel.totalMonthExpenses > 2500 {
            score -= 35
        } else if viewModel.totalMonthExpenses > 2000 {
            score -= 25
        } else if viewModel.totalMonthExpenses > 1500 {
            score -= 15
        } else if viewModel.totalMonthExpenses > 1000 {
            score -= 10
        }

        // Reward good habits
        if !viewModel.budgets.isEmpty {
            score += 15
        }
        if !viewModel.savingsGoals.isEmpty {
            score += 15
        }
        if !viewModel.recurringExpenses.isEmpty {
            score += 10
        }

        // Penalize excessive daily average
        if dailyAverage > 100 {
            score -= 10
        }

        return max(0, min(100, score))
    }

    private func scoreColor(_ score: Double) -> Color {
        if score >= 80 {
            return AppTheme.success  // Green
        } else if score >= 60 {
            return .yellow   // Yellow
        } else if score >= 40 {
            return AppTheme.accent   // Orange
        } else {
            return AppTheme.danger  // Red
        }
    }

    private func scoreLabel(_ score: Double) -> String {
        if score >= 80 {
            return "Excelente"
        } else if score >= 60 {
            return "Bueno"
        } else if score >= 40 {
            return "Regular"
        } else {
            return "Mejorable"
        }
    }
}
