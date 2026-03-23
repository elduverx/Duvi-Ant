import Foundation
import SwiftUI

#if !targetEnvironment(simulator)
import FinanceKit

/// Implementación real corregida para la API de iOS 18 FinanceKit (WWDC 2024)
@MainActor
final class RealFinanceStore: FinanceStoreProtocol {
    private let financeStore = FinanceStore.shared

    func requestAuthorization() async throws -> Bool {
        let status = try await financeStore.authorizationStatus()
        if status == .authorized { return true }
        return try await financeStore.requestAuthorization() == .authorized
    }

    func fetchAccounts() async throws -> [FinanceAccountProtocol] {
        // Query para obtener todas las cuentas
        let accounts = try await financeStore.accounts(query: AccountQuery())
        
        // Obtener balances
        let balances = try await financeStore.accountBalances(query: AccountBalanceQuery())
        
        return accounts.map { account in
            let balance = balances.first(where: { $0.accountID == account.id })
            return RealFinanceAccount(account: account, balanceObj: balance)
        }
    }

    func fetchTransactions(for accountID: String, from startDate: Date) async throws -> [FinanceTransactionProtocol] {
        guard let accountUUID = UUID(uuidString: accountID) else { return [] }
        
        // Query de transacciones usando el predicado nativo
        let predicate = #Predicate<FinanceKit.Transaction> { transaction in
            transaction.accountID == accountUUID
        }
        
        let query = TransactionQuery(predicate: predicate)
        let allTransactions = try await financeStore.transactions(query: query)
        
        return allTransactions
            .filter { $0.transactionDate >= startDate }
            .map { RealFinanceTransaction(transaction: $0) }
    }
}

// MARK: - Wrappers Reales

struct RealFinanceAccount: FinanceAccountProtocol {
    let account: FinanceKit.Account
    let balanceObj: FinanceKit.AccountBalance?

    var id: String { account.id.uuidString }
    var displayName: String? { account.displayName }
    var institutionName: String { account.institutionName }
    var accountDescription: String? { account.displayName }
    
    var balance: Double { 
        // En iOS 18, AccountBalance tiene propiedades available y booked de tipo Balance.
        // Cada Balance tiene una propiedad amount que es CurrencyAmount.
        // Cada CurrencyAmount tiene una propiedad amount que es Decimal.
        let amount = balanceObj?.available?.amount.amount ?? balanceObj?.booked?.amount.amount ?? Decimal(0)
        return Double(truncating: amount as NSNumber)
    }
    
    var accountIdentifier: String { 
        // Usamos los últimos 4 dígitos del ID como identificador si no hay uno explícito
        String(account.id.uuidString.suffix(4))
    }
}

struct RealFinanceTransaction: FinanceTransactionProtocol {
    let transaction: FinanceKit.Transaction

    var id: String { transaction.id.uuidString }
    
    var amount: Double { 
        let val = transaction.transactionAmount.amount
        return Double(truncating: val as NSNumber)
    }
    
    var date: Date { transaction.transactionDate }
    
    var merchantName: String? { 
        transaction.merchantName 
    } 
    
    var transactionDescription: String { transaction.transactionDescription }
    
    var isPending: Bool { 
        transaction.status == .pending
    }
    
    var isIncome: Bool { 
        // Podríamos usar el creditDebitIndicator si está disponible en esta versión
        amount > 0 
    }
}

#endif
