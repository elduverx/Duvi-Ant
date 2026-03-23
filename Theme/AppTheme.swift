import SwiftUI
import UIKit

struct AppTheme {
    // MARK: - Colors (Dynamic Professional Palette)
    
    /// Primary professional blue, slightly brighter in dark mode for contrast
    static let primary = Color(uiColor: UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.35, green: 0.55, blue: 1.0, alpha: 1.0)
            : UIColor(red: 0.2, green: 0.4, blue: 0.95, alpha: 1.0)
    })
    
    static let secondary = Color(uiColor: UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.2, green: 0.9, blue: 0.7, alpha: 1.0)
            : UIColor(red: 0.1, green: 0.8, blue: 0.6, alpha: 1.0)
    })
    
    static let accent = Color(uiColor: UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 1.0, green: 0.6, blue: 0.3, alpha: 1.0)
            : UIColor(red: 0.95, green: 0.5, blue: 0.2, alpha: 1.0)
    })

    static let danger = Color(uiColor: UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 1.0, green: 0.4, blue: 0.4, alpha: 1.0)
            : UIColor(red: 0.95, green: 0.3, blue: 0.3, alpha: 1.0)
    })
    
    static let success = Color(uiColor: UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.3, green: 0.95, blue: 0.5, alpha: 1.0)
            : UIColor(red: 0.2, green: 0.85, blue: 0.4, alpha: 1.0)
    })

    // MARK: - Backgrounds & Surfaces
    
    static let background = Color(uiColor: .systemGroupedBackground)
    static let secondaryBackground = Color(uiColor: .secondarySystemGroupedBackground)
    static let tertiaryBackground = Color(uiColor: .tertiarySystemGroupedBackground)
    
    static let cardBackground = Color(uiColor: UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.12, green: 0.12, blue: 0.14, alpha: 1.0)
            : .white
    })

    // MARK: - Text
    
    static let text = Color.primary
    static let textSecondary = Color.secondary

    // MARK: - Spacing
    static let spacing = Spacing()

    struct Spacing {
        let xs: CGFloat = 4
        let sm: CGFloat = 8
        let md: CGFloat = 12
        let lg: CGFloat = 16
        let xl: CGFloat = 24
        let xxl: CGFloat = 32
    }

    // MARK: - Corner Radius
    static let cornerSmall: CGFloat = 8
    static let cornerMedium: CGFloat = 12
    static let cornerLarge: CGFloat = 16
    static let cornerXL: CGFloat = 20
    static let cornerXXL: CGFloat = 24

    // MARK: - Shadows
    static func shadow(color: Color = .black, radius: CGFloat = 8, x: CGFloat = 0, y: CGFloat = 4) -> (Color, CGFloat, CGFloat, CGFloat) {
        let shadowColor = Color(uiColor: UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark
                ? UIColor.black.withAlphaComponent(0.3)
                : UIColor.black.withAlphaComponent(0.08)
        })
        return (shadowColor, radius, x, y)
    }
}

// MARK: - View Modifiers
extension View {
    func cardStyle(backgroundColor: Color = AppTheme.cardBackground) -> some View {
        let (sColor, sRadius, sX, sY) = AppTheme.shadow()
        return self
            .padding(AppTheme.spacing.lg)
            .background(backgroundColor)
            .cornerRadius(AppTheme.cornerLarge)
            .shadow(color: sColor, radius: sRadius, x: sX, y: sY)
    }

    func primaryButtonStyle() -> some View {
        self
            .frame(maxWidth: .infinity)
            .padding(AppTheme.spacing.lg)
            .background(AppTheme.primary)
            .foregroundColor(.white)
            .cornerRadius(AppTheme.cornerMedium)
            .font(.system(size: 16, weight: .bold))
    }

    func secondaryButtonStyle() -> some View {
        self
            .frame(maxWidth: .infinity)
            .padding(AppTheme.spacing.lg)
            .background(AppTheme.secondaryBackground)
            .foregroundColor(AppTheme.primary)
            .cornerRadius(AppTheme.cornerMedium)
            .font(.system(size: 16, weight: .semibold))
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerMedium)
                    .stroke(AppTheme.primary, lineWidth: 1.5)
            )
    }
    
    func glassStyle() -> some View {
        self
            .background(
                VisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
                    .cornerRadius(AppTheme.cornerLarge)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerLarge)
                    .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
            )
    }
}

// MARK: - Visual Effect View
struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: Context) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) { uiView.effect = effect }
}
