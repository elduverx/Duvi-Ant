import Foundation

// MARK: - Implementación Mock para Desarrollo

/// Implementación mock de FinanceStore para desarrollo y simulador
final class MockFinanceStore: FinanceStoreProtocol {

    private var isAuthorized = false
    private let mockAccounts: [MockFinanceAccount]

    nonisolated init() {
        // Crear cuentas mock realistas
        self.mockAccounts = [
            MockFinanceAccount(
                id: UUID().uuidString,
                displayName: "Apple Card",
                institutionName: "Goldman Sachs",
                accountDescription: "Tarjeta de crédito Apple",
                balance: 1250.50,
                accountIdentifier: "****4521",
                accountTypeHint: .creditCard
            ),
            MockFinanceAccount(
                id: UUID().uuidString,
                displayName: "Cuenta de Ahorros",
                institutionName: "Banco Santander",
                accountDescription: "Cuenta de ahorros personal",
                balance: 8750.25,
                accountIdentifier: "****8912",
                accountTypeHint: .savings
            ),
            MockFinanceAccount(
                id: UUID().uuidString,
                displayName: "Cuenta Corriente",
                institutionName: "BBVA",
                accountDescription: "Cuenta corriente principal",
                balance: 3420.80,
                accountIdentifier: "****1234",
                accountTypeHint: .checking
            )
        ]
    }

    func requestAuthorization() async throws -> Bool {
        // Simular delay de autorización
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 segundo
        isAuthorized = true
        return true
    }

    func fetchAccounts() async throws -> [FinanceAccountProtocol] {
        guard isAuthorized else {
            throw FinanceKitError.notAuthorized
        }

        // Simular delay de red
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 segundos
        return mockAccounts
    }

    func fetchTransactions(for accountID: String, from startDate: Date) async throws -> [FinanceTransactionProtocol] {
        guard isAuthorized else {
            throw FinanceKitError.notAuthorized
        }

        // Generar transacciones mock para la cuenta
        return generateMockTransactions(for: accountID, from: startDate)
    }

    // MARK: - Helpers

    private func generateMockTransactions(for accountID: String, from startDate: Date) -> [MockFinanceTransaction] {
        let merchants = [
            "Mercadona", "Carrefour", "Starbucks", "Netflix", "Spotify",
            "Amazon", "Apple Store", "Zara", "Uber", "Repsol",
            "Restaurante La Terraza", "Farmacia", "Gimnasio FitLife"
        ]

        var transactions: [MockFinanceTransaction] = []
        let calendar = Calendar.current

        // Generar ~30 transacciones en el último mes
        for i in 0..<30 {
            guard let date = calendar.date(byAdding: .day, value: -i, to: Date()) else { continue }

            if date < startDate { break }

            let merchant = merchants.randomElement() ?? "Comercio"
            let amount = Double.random(in: 5.0...150.0)
            let isIncome = Double.random(in: 0...1) > 0.85 // 15% son ingresos

            transactions.append(MockFinanceTransaction(
                id: UUID().uuidString,
                amount: isIncome ? amount : -amount,
                date: date,
                merchantName: merchant,
                transactionDescription: isIncome ? "Transferencia recibida" : "Compra en \(merchant)",
                isPending: i < 2, // Las 2 más recientes están pendientes
                isIncome: isIncome
            ))
        }

        return transactions.sorted { $0.date > $1.date }
    }
}

// MARK: - Tipos Mock

struct MockFinanceAccount: FinanceAccountProtocol {
    let id: String
    let displayName: String?
    let institutionName: String
    let accountDescription: String?
    let balance: Double
    let accountIdentifier: String
    let accountTypeHint: AccountTypeHint

    enum AccountTypeHint {
        case creditCard, savings, checking, debit
    }
}

struct MockFinanceTransaction: FinanceTransactionProtocol {
    let id: String
    let amount: Double
    let date: Date
    let merchantName: String?
    let transactionDescription: String
    let isPending: Bool
    let isIncome: Bool
}

// MARK: - Errores

enum FinanceKitError: LocalizedError {
    case notAuthorized
    case accountNotFound
    case networkError

    var errorDescription: String? {
        switch self {
        case .notAuthorized:
            return "No tienes autorización para acceder a datos financieros"
        case .accountNotFound:
            return "Cuenta no encontrada"
        case .networkError:
            return "Error de red al sincronizar datos"
        }
    }
}
