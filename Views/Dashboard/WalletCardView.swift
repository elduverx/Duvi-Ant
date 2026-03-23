import SwiftUI

struct WalletCardView: View {
    let account: BankAccount

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header: Logo & Type
            HStack {
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: account.iconName)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(account.institutionName)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(account.accountType.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Image(systemName: "contact.sensor.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white.opacity(0.6))
                    .rotationEffect(.degrees(90))
            }
            
            Spacer()
            
            // Balance
            VStack(alignment: .leading, spacing: 4) {
                Text("Saldo Actual")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))
                    .textCase(.uppercase)
                
                Text("$\(account.currentBalance, specifier: "%.2f")")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            
            // Footer: Numbers
            HStack {
                Text("•••• •••• •••• \(account.lastFourDigits ?? "0000")")
                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                    .foregroundColor(.white.opacity(0.9))
                
                Spacer()
                
                if let creditLimit = account.creditLimit, account.accountType == .creditCard {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Límite")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white.opacity(0.6))
                        Text("$\(creditLimit, specifier: "%.0f")")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding(24)
        .frame(width: 320, height: 200)
        .background(
            ZStack {
                cardColor
                
                // Abstract Shapes for "Apple Wallet" look
                Circle()
                    .fill(.white.opacity(0.1))
                    .frame(width: 200, height: 200)
                    .offset(x: 150, y: -100)
                
                Circle()
                    .fill(.black.opacity(0.05))
                    .frame(width: 150, height: 150)
                    .offset(x: -100, y: 80)
            }
        )
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
    
    private var cardColor: LinearGradient {
        switch account.color.lowercased() {
        case "blue":
            return LinearGradient(colors: [Color(hex: "1E3A8A"), Color(hex: "3B82F6")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "green":
            return LinearGradient(colors: [Color(hex: "064E3B"), Color(hex: "10B981")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "red":
            return LinearGradient(colors: [Color(hex: "7F1D1D"), Color(hex: "EF4444")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "orange":
            return LinearGradient(colors: [Color(hex: "7C2D12"), Color(hex: "F97316")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "purple":
            return LinearGradient(colors: [Color(hex: "4C1D95"), Color(hex: "8B5CF6")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "black":
            return LinearGradient(colors: [Color(hex: "111827"), Color(hex: "4B5563")], startPoint: .topLeading, endPoint: .bottomTrailing)
        default:
            return LinearGradient(colors: [Color(hex: "1E40AF"), Color(hex: "60A5FA")], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}

// Extension to handle Hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    let mockAccount = BankAccount(
        financeKitAccountID: "mock-1",
        institutionName: "Apple Card",
        accountType: .creditCard,
        displayName: "Titanium Card",
        lastFourDigits: "8899",
        currentBalance: 1245.50,
        creditLimit: 5000,
        color: "black",
        iconName: "applelogo"
    )
    
    return WalletCardView(account: mockAccount)
        .padding()
}
