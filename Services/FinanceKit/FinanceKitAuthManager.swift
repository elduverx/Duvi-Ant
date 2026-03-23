import Foundation
import SwiftUI

@Observable
@MainActor
final class FinanceKitAuthManager {
    private let financeStore: FinanceStoreProtocol

    var isAuthorized: Bool = false
    var authError: Error?
    var authorizationStatus: AuthStatus = .notDetermined

    enum AuthStatus {
        case notDetermined
        case authorized
        case denied
        case restricted
    }

    init(financeStore: FinanceStoreProtocol = MockFinanceStore()) {
        self.financeStore = financeStore
    }

    func checkAuthorizationStatus() async {
        // En la implementación real con FinanceKit, aquí verificarías el estado
        // Por ahora, asumimos que necesita autorización
        if !isAuthorized {
            authorizationStatus = .notDetermined
        } else {
            authorizationStatus = .authorized
        }
    }

    func requestAuthorization() async {
        do {
            let granted = try await financeStore.requestAuthorization()
            isAuthorized = granted
            authorizationStatus = granted ? .authorized : .denied
            authError = nil
        } catch {
            authError = error
            authorizationStatus = .denied
            isAuthorized = false
            print("Error requesting FinanceKit auth: \(error)")
        }
    }
}
