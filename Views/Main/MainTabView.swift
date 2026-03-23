import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab: Tab = .expenses
    @State private var viewModel: ExpenseViewModel?

    enum Tab {
        case expenses
        case recurring
        case goals
        case analytics
        case settings
    }

    var body: some View {
        if let vm = viewModel {
            TabView(selection: $selectedTab) {
                // Gastos
                ContentView()
                    .tabItem {
                        Label("Gastos", systemImage: "list.bullet")
                    }
                    .tag(Tab.expenses)

                // Gastos Recurrentes
                RecurringExpensesView(viewModel: vm)
                    .tabItem {
                        Label("Recurrentes", systemImage: "repeat.circle")
                    }
                    .tag(Tab.recurring)

                // Metas de Ahorro
                SavingsGoalsView(viewModel: vm)
                    .tabItem {
                        Label("Metas", systemImage: "target")
                    }
                    .tag(Tab.goals)

                // Análisis Avanzados
                AnalyticsView(viewModel: vm)
                    .tabItem {
                        Label("Análisis", systemImage: "chart.bar.fill")
                    }
                    .tag(Tab.analytics)

                // Ajustes
                SettingsView()
                    .tabItem {
                        Label("Ajustes", systemImage: "gear")
                    }
                    .tag(Tab.settings)
            }
        } else {
            ProgressView("Preparando hormiguero...")
                .onAppear {
                    viewModel = ExpenseViewModel(modelContext: modelContext)
                }
        }
    }
}

#Preview {
    MainTabView()
}
