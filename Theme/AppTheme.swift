import SwiftUI

struct AppTheme {
    // MARK: - Colors
    struct Colors {
        static let primary = Color("Primary")
        static let secondary = Color("Secondary")
        static let accent = Color("Accent")
        static let background = Color("Background")
        static let surface = Color("Surface")
        static let text = Color("Text")
        static let textSecondary = Color("TextSecondary")
        
        // Gradient Colors
        static let gradientStart = Color("GradientStart")
        static let gradientEnd = Color("GradientEnd")
    }
    
    // MARK: - Typography
    struct Typography {
        static let largeTitle = Font.system(size: 34, weight: .bold)
        static let title = Font.system(size: 28, weight: .bold)
        static let title2 = Font.system(size: 22, weight: .bold)
        static let headline = Font.system(size: 17, weight: .semibold)
        static let body = Font.system(size: 17, weight: .regular)
        static let callout = Font.system(size: 16, weight: .regular)
        static let subheadline = Font.system(size: 15, weight: .regular)
        static let footnote = Font.system(size: 13, weight: .regular)
        static let caption = Font.system(size: 12, weight: .regular)
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xlarge: CGFloat = 24
    }
    
    // MARK: - Shadows
    struct Shadows {
        static let small = Shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        static let medium = Shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        static let large = Shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 8)
    }
    
    // MARK: - Animations
    struct Animations {
        static let standard = Animation.easeInOut(duration: 0.3)
        static let spring = Animation.spring(response: 0.3, dampingFraction: 0.7)
        static let quick = Animation.easeInOut(duration: 0.2)
    }
}

// MARK: - View Modifiers
extension View {
    func cardStyle() -> some View {
        self
            .background(AppTheme.Colors.surface)
            .cornerRadius(AppTheme.CornerRadius.medium)
            .shadow(color: AppTheme.Shadows.small.color, radius: AppTheme.Shadows.small.radius, x: AppTheme.Shadows.small.x, y: AppTheme.Shadows.small.y)
    }
    
    func gradientBackground() -> some View {
        self
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [AppTheme.Colors.gradientStart, AppTheme.Colors.gradientEnd]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
}