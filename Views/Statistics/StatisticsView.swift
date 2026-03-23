import SwiftUI
import Charts

struct StatisticsView: View {
    let viewModel: ExpenseViewModel
    @State private var animateChart = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Hero Card - Estilo Fitness+
                    heroCard

                    // Ring Progress - Estilo Fitness+
                    progressRingsCard

                    // Gráfico de categorías - Barras horizontales
                    categoryChartCard

                    // Tendencia semanal - Área Chart
                    weekTrendCard
                }
                .padding()
            }
            .background(AppTheme.background)
            .navigationTitle("Estadísticas")
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0)) {
                    animateChart = true
                }
            }
        }
    }

    // MARK: - Hero Card (Fitness+ Style)

    private var heroCard: some View {
        VStack(spacing: 16) {
            // Número grande prominente
            VStack(spacing: 8) {
                Text("Total del Mes")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.8))

                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("$")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("\(viewModel.totalMonthExpenses, format: .number.precision(.fractionLength(0))))")
                        .font(.system(size: 56, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                }
            }
            .padding(.top, 20)

            // Métricas secundarias
            HStack(spacing: 0) {
                metricView(
                    title: "Gastos",
                    value: "\(viewModel.expenses.count)",
                    icon: "list.bullet"
                )

                Divider()
                    .background(Color.white.opacity(0.3))
                    .frame(height: 40)

                metricView(
                    title: "Promedio",
                    value: "$\(Int(averageExpense))",
                    icon: "chart.bar.fill"
                )

                Divider()
                    .background(Color.white.opacity(0.3))
                    .frame(height: 40)

                metricView(
                    title: "Máximo",
                    value: "$\(Int(maxExpense))",
                    icon: "arrow.up.circle.fill"
                )
            }
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    AppTheme.primary,
                    AppTheme.primary.opacity(0.8),
                    AppTheme.secondary
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(AppTheme.cornerXL)
        .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
    }

    private func metricView(title: String, value: String, icon: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white.opacity(0.9))

            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.white)

            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Progress Rings (Fitness+ Style)

    private var progressRingsCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Progreso por Categoría")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            HStack(spacing: 20) {
                ForEach(Array(categoryData.prefix(3).enumerated()), id: \.element.categoryName) { index, data in
                    progressRing(
                        category: data.categoryName,
                        amount: data.total,
                        color: categoryColor(index: index),
                        progress: viewModel.totalMonthExpenses > 0 ? data.total / viewModel.totalMonthExpenses : 0
                    )
                }
            }
        }
        .padding(24)
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cornerXL)
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
    }

    private func progressRing(category: String, amount: Double, color: Color, progress: Double) -> some View {
        VStack(spacing: 12) {
            ZStack {
                // Ring background
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 8)
                    .frame(width: 80, height: 80)

                // Progress ring
                Circle()
                    .trim(from: 0, to: animateChart ? progress : 0)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [color.opacity(0.7), color]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.0), value: animateChart)

                // Center value
                Text("$\(amount, format: .number.precision(.fractionLength(0))))")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(color)
            }

            Text(category)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Category Chart (Horizontal Bars - Fitness+ Style)

    private var categoryChartCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Gastos por Categoría")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            if categoryData.isEmpty {
                Text("Sin datos")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
            } else {
                Chart(categoryData, id: \.categoryName) { data in
                    BarMark(
                        x: .value("Monto", animateChart ? data.total : 0),
                        y: .value("Categoría", data.categoryName)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                AppTheme.primary.opacity(0.8),
                                AppTheme.secondary.opacity(0.8)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(AppTheme.cornerSmall)
                }
                .frame(height: CGFloat(categoryData.count * 50))
                .chartXAxis {
                    AxisMarks(position: .bottom)
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisValueLabel()
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .animation(.easeInOut(duration: 1.0), value: animateChart)
            }
        }
        .padding(24)
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cornerXL)
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
    }

    // MARK: - Week Trend (Area Chart - Fitness+ Style)

    private var weekTrendCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Últimos 7 Días")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            if weekData.isEmpty {
                Text("Sin datos")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
            } else {
                Chart(weekData, id: \.date) { data in
                    AreaMark(
                        x: .value("Día", data.date, unit: .day),
                        y: .value("Monto", animateChart ? data.total : 0)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: AppTheme.primary.opacity(0.5), location: 0),
                                .init(color: AppTheme.primary.opacity(0.2), location: 0.5),
                                .init(color: AppTheme.primary.opacity(0.0), location: 1)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .interpolationMethod(.catmullRom)

                    LineMark(
                        x: .value("Día", data.date, unit: .day),
                        y: .value("Monto", animateChart ? data.total : 0)
                    )
                    .foregroundStyle(AppTheme.primary)
                    .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                    .interpolationMethod(.catmullRom)
                    .symbol {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 8, height: 8)
                            .overlay(
                                Circle()
                                    .stroke(AppTheme.primary, lineWidth: 2)
                            )
                    }
                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { value in
                        AxisValueLabel(format: .dateTime.weekday(.narrow))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisValueLabel()
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .animation(.easeInOut(duration: 1.0), value: animateChart)
            }
        }
        .padding(24)
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cornerXL)
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
    }

    // MARK: - Computed Properties

    private var averageExpense: Double {
        guard !viewModel.expenses.isEmpty else { return 0 }
        return viewModel.totalMonthExpenses / Double(viewModel.expenses.count)
    }

    private var maxExpense: Double {
        viewModel.expenses.map { $0.amount }.max() ?? 0
    }

    private var categoryData: [(categoryName: String, categoryIcon: String, total: Double)] {
        var result: [(categoryName: String, categoryIcon: String, total: Double)] = []
        let grouped = Dictionary(grouping: viewModel.expenses, by: { $0.category?.name ?? "Sin categoría" })

        for (name, expenses) in grouped {
            let total = expenses.reduce(0) { $0 + $1.amount }
            let icon = viewModel.expenses.first { $0.category?.name == name }?.category?.icon ?? "questionmark.circle"
            result.append((categoryName: name, categoryIcon: icon, total: total))
        }

        return result.sorted { $0.total > $1.total }
    }

    private var weekData: [(date: Date, total: Double)] {
        let calendar = Calendar.current
        let today = Date()
        let sevenDaysAgo = calendar.date(byAdding: .day, value: -6, to: today)!

        var dailyTotals: [Date: Double] = [:]

        for expense in viewModel.expenses {
            if expense.date >= sevenDaysAgo && expense.date <= today {
                let dateComponent = calendar.dateComponents([.year, .month, .day], from: expense.date)
                let dateOnly = calendar.date(from: dateComponent)!
                dailyTotals[dateOnly, default: 0] += expense.amount
            }
        }

        var result: [(date: Date, total: Double)] = []
        for i in 0..<7 {
            let date = calendar.date(byAdding: .day, value: -6 + i, to: today)!
            let dateComponent = calendar.dateComponents([.year, .month, .day], from: date)
            let dateOnly = calendar.date(from: dateComponent)!
            result.append((dateOnly, dailyTotals[dateOnly] ?? 0))
        }

        return result
    }

    private func categoryColor(index: Int) -> Color {
        let colors = [
            AppTheme.primary,
            AppTheme.success,
            AppTheme.accent
        ]
        return colors[index % colors.count]
    }
}
