import Foundation
import SwiftData

@MainActor
final class BankAccountService {
    private let financeStore: FinanceStoreProtocol
    private let modelContext: ModelContext

    init(modelContext: ModelContext, financeStore: FinanceStoreProtocol = MockFinanceStore()) {
        self.modelContext = modelContext
        self.financeStore = financeStore
    }

    // MARK: - Fetch Accounts from FinanceKit
    func syncAccounts() async throws -> [BankAccount] {
        // Fetch all accounts from FinanceKit (or mock)
        let financeKitAccounts = try await financeStore.fetchAccounts()

        var syncedAccounts: [BankAccount] = []

        for fkAccount in financeKitAccounts {
            // Check if account already exists in SwiftData
            let accountID = fkAccount.id // Capturar ID fuera del predicate
            let predicate = #Predicate<BankAccount> { account in
                account.financeKitAccountID == accountID
            }

            let descriptor = FetchDescriptor<BankAccount>(predicate: predicate)
            let existing = try? modelContext.fetch(descriptor).first

            if let existingAccount = existing {
                // Update existing account
                updateAccount(existingAccount, with: fkAccount)
                syncedAccounts.append(existingAccount)
            } else {
                // Create new account
                let newAccount = createAccount(from: fkAccount)
                modelContext.insert(newAccount)
                syncedAccounts.append(newAccount)
            }
        }

        try modelContext.save()
        return syncedAccounts
    }

    // MARK: - Account Mapping
    private func createAccount(from fkAccount: FinanceAccountProtocol) -> BankAccount {
        let accountType = inferAccountType(from: fkAccount)
        let institution = fkAccount.institutionName
        
        // Extraer los últimos 4 dígitos si están disponibles en el identificador
        let lastFour = fkAccount.accountIdentifier.suffix(4)
        
        return BankAccount(
            financeKitAccountID: fkAccount.id,
            institutionName: institution,
            accountType: accountType,
            displayName: fkAccount.displayName,
            lastFourDigits: String(lastFour),
            currentBalance: fkAccount.balance,
            availableCredit: nil,
            creditLimit: accountType == .creditCard ? 5000 : nil, // Mock limit for now
            color: assignColor(for: institution),
            iconName: iconForAccountType(accountType, institution: institution)
        )
    }

    private func updateAccount(_ account: BankAccount, with fkAccount: FinanceAccountProtocol) {
        account.currentBalance = fkAccount.balance
        account.lastSynced = Date()
        account.institutionName = fkAccount.institutionName
        account.displayName = fkAccount.displayName
        // Update identifier if changed
        account.lastFourDigits = String(fkAccount.accountIdentifier.suffix(4))
    }

    private func inferAccountType(from account: FinanceAccountProtocol) -> BankAccount.AccountType {
        // Intentar inferir el tipo basado en el nombre o descripción
        let description = ((account.displayName ?? "") + account.institutionName).lowercased()

        if description.contains("credit") || description.contains("crédito") {
            return .creditCard
        } else if description.contains("savings") || description.contains("ahorro") {
            return .savings
        } else if description.contains("checking") || description.contains("corriente") {
            return .checking
        } else if description.contains("debit") || description.contains("débito") {
            return .debit
        }

        // Si tenemos MockFinanceAccount, usar el hint
        if let mockAccount = account as? MockFinanceAccount {
            switch mockAccount.accountTypeHint {
            case .creditCard: return .creditCard
            case .savings: return .savings
            case .checking: return .checking
            case .debit: return .debit
            }
        }

        return .unknown
    }

    private func assignColor(for institution: String) -> String {
        let name = institution.lowercased()
        
        if name.contains("apple") { return "black" }
        if name.contains("chase") || name.contains("santander") { return "blue" }
        if name.contains("amex") || name.contains("american express") { return "blue" }
        if name.contains("bbva") || name.contains("wells fargo") { return "blue" }
        if name.contains("nubank") || name.contains("itau") { return "purple" }
        if name.contains("bank of america") { return "red" }
        if name.contains("fidelity") || name.contains("td bank") { return "green" }
        if name.contains("goldman") { return "black" }
        
        // Random but consistent based on string hash
        let colors = ["blue", "purple", "green", "black", "orange", "red"]
        let index = abs(name.hashValue) % colors.count
        return colors[index]
    }

    private func iconForAccountType(_ type: BankAccount.AccountType, institution: String) -> String {
        if institution.lowercased().contains("apple") {
            return "applelogo"
        }
        
        switch type {
        case .creditCard: return "creditcard.fill"
        case .debit: return "rectangle.portrait.and.arrow.forward.fill"
        case .checking: return "building.columns.fill"
        case .savings: return "leaf.fill"
        case .unknown: return "questionmark.circle.fill"
        }
    }
}
