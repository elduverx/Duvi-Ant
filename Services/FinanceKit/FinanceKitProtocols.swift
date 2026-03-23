import Foundation

// MARK: - Protocolos de Abstracción para FinanceKit
// Estos protocolos nos permiten trabajar con datos mock ahora
// e implementar la versión real con dispositivo físico después

/// Protocolo que abstrae el FinanceStore
protocol FinanceStoreProtocol {
    func requestAuthorization() async throws -> Bool
    func fetchAccounts() async throws -> [FinanceAccountProtocol]
    func fetchTransactions(for accountID: String, from startDate: Date) async throws -> [FinanceTransactionProtocol]
}

/// Protocolo que representa una cuenta financiera
protocol FinanceAccountProtocol {
    var id: String { get }
    var displayName: String? { get }
    var institutionName: String { get }
    var accountDescription: String? { get }
    var balance: Double { get }
    var accountIdentifier: String { get } // e.g., last 4 digits
}

/// Protocolo que representa una transacción
protocol FinanceTransactionProtocol {
    var id: String { get }
    var amount: Double { get }
    var date: Date { get }
    var merchantName: String? { get }
    var transactionDescription: String { get }
    var isPending: Bool { get }
    var isIncome: Bool { get }
}

// MARK: - Wrapper para Account de FinanceKit
// Cuando implementemos la versión real, crearemos un wrapper que
// tome un `Account` de FinanceKit y conforme a este protocolo

#if !targetEnvironment(simulator)
import FinanceKit

// TODO: Implementar cuando tengamos dispositivo físico
// struct RealFinanceAccount: FinanceAccountProtocol {
//     let account: Account
//
//     var id: String { account.id.uuidString }
//     var displayName: String? { account.displayName }
//     var institutionName: String { /* extraer del account */ }
//     ... etc
// }
#endif
