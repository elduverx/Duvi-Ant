import Foundation

struct ReportGenerator {
    let viewModel: ExpenseViewModel

    func generatePDFReport() -> URL? {

        let fileName = "DuviAnt_Reporte_\(Date().formatted(date: .abbreviated, time: .omitted)).pdf"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        // Crear contenido básico del PDF
        var reportText = "=== REPORTE DE GASTOS DUVI ANT ===\n\n"
        reportText += "Fecha: \(Date().formatted(date: .abbreviated, time: .omitted))\n\n"
        reportText += "RESUMEN MENSUAL\n"
        let totalText = String(format: "%.2f", viewModel.totalMonthExpenses)
        reportText += "Total este mes: $\(totalText)\n\n"
        reportText += "GASTOS POR CATEGORÍA\n"

        for category in viewModel.categories {
            let total = viewModel.expensesForCategory(category)
            if total > 0 {
                let totalText = String(format: "%.2f", total)
                reportText += "\(category.name): $\(totalText)\n"
            }
        }

        reportText += "\nESTADO DE PRESUPUESTOS\n"
        for budget in viewModel.budgets {
            let status = budget.isExceeded(expenses: viewModel.expenses) ? "EXCEDIDO" : "OK"
            let limitText = String(format: "%.2f", budget.limit)
            reportText += "\(budget.category?.name ?? "General"): $\(limitText) - \(status)\n"
        }

        do {
            try reportText.write(to: url, atomically: true, encoding: .utf8)
            return url
        } catch {
            print("Error generando reporte: \(error)")
            return nil
        }
    }
}
