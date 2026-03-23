import SwiftUI

struct SavingsGoalsView: View {
    let viewModel: ExpenseViewModel
    @State private var showingAddGoal = false

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.savingsGoals.isEmpty {
                    ContentUnavailableView(
                        "Sin metas de ahorro",
                        systemImage: "target",
                        description: Text("Crea una meta para ahorrar y alcanzar tus objetivos.")
                    )
                } else {
                    List {
                        ForEach(viewModel.savingsGoals) { goal in
                            GoalCard(goal: goal)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        viewModel.deleteGoal(goal)
                                    } label: {
                                        Label("Borrar", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Metas de Ahorro")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddGoal = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddGoal) {
                AddGoalSheet(viewModel: viewModel)
            }
        }
    }
}

struct GoalCard: View {
    let goal: SavingsGoal

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: goal.emoji)
                    .font(.system(size: 20, weight: .semibold))
                    .frame(width: 48, height: 48)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                AppTheme.primary.opacity(0.12),
                                AppTheme.secondary.opacity(0.06)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(AppTheme.cornerMedium)
                    .foregroundColor(AppTheme.primary)

                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)

                    Text("Meta: $\(goal.targetAmount, specifier: "%.2f")")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("$\(goal.currentAmount, specifier: "%.2f")")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(AppTheme.primary)

                    Text("\(Int(goal.progress))%")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(goal.isCompleted ? AppTheme.success : AppTheme.accent)
                }
            }

            ProgressView(value: min(goal.progress / 100, 1.0))
                .tint(goal.isCompleted ? AppTheme.success : (goal.isOverdue ? AppTheme.danger : AppTheme.accent))

            HStack(spacing: 12) {
                if goal.isCompleted {
                    Label("¡Completado!", systemImage: "checkmark.circle.fill")
                        .font(.caption2)
                        .foregroundColor(AppTheme.success)
                } else {
                    Label("Faltan $\(goal.remainingAmount, specifier: "%.2f")", systemImage: "dollarsign.circle")
                        .font(.caption2)
                        .foregroundColor(.secondary)

                    Label("\(goal.daysRemaining)d", systemImage: "calendar")
                        .font(.caption2)
                        .foregroundColor(goal.isOverdue ? AppTheme.danger : .secondary)
                }
            }
        }
        .padding(12)
        .background(AppTheme.secondaryBackground)
        .cornerRadius(AppTheme.cornerMedium)
    }
}

// Preview removed - test in MainTabView instead
