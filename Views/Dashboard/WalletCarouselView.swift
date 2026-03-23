import SwiftUI

struct WalletCarouselView: View {
    let accounts: [BankAccount]
    let onSyncRequested: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Mis Tarjetas y Cuentas")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: onSyncRequested) {
                    Label("Sincronizar", systemImage: "arrow.triangle.2.circlepath")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .controlSize(.small)
            }
            .padding(.horizontal, 16)
            
            if accounts.isEmpty {
                Button(action: onSyncRequested) {
                    VStack(spacing: 12) {
                        Image(systemName: "creditcard.and.123")
                            .font(.system(size: 40))
                            .foregroundColor(.accentColor)
                        
                        Text("Conecta tus cuentas de Wallet")
                            .font(.headline)
                        
                        Text("Sincroniza con FinanceKit para ver tus tarjetas aquí.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(32)
                    .background(Color.accentColor.opacity(0.05))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6]))
                            .foregroundColor(.accentColor.opacity(0.3))
                    )
                }
                .padding(.horizontal, 16)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(accounts) { account in
                            WalletCardView(account: account)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                }
            }
        }
    }
}

#Preview {
    WalletCarouselView(accounts: [
        BankAccount(financeKitAccountID: "1", institutionName: "Apple Card", accountType: .creditCard, lastFourDigits: "8899", currentBalance: 1200, color: "black", iconName: "applelogo"),
        BankAccount(financeKitAccountID: "2", institutionName: "Chase", accountType: .checking, lastFourDigits: "4422", currentBalance: 5430.20, color: "blue", iconName: "building.columns.fill")
    ], onSyncRequested: {})
}
