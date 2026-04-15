import SwiftUI

struct CapsuleButton<Label: View>: View {
    let action: () -> Void
    let label: () -> Label
    let style: Style
    
    enum Style {
        case primary
        case secondary
        case link
        
        var backgroundColor: Color {
            switch self {
            case .primary:
                return Color(red: 0.0, green: 0.48, blue: 1.0)
            case .secondary:
                return Color(white: 0.96)
            case .link:
                return Color(red: 0.0, green: 0.48, blue: 1.0).opacity(0.1)
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .primary:
                return .white
            case .secondary:
                return .primary
            case .link:
                return Color(red: 0.0, green: 0.48, blue: 1.0)
            }
        }
    }
    
    init(
        style: Style = .primary,
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.style = style
        self.action = action
        self.label = label
    }
    
    var body: some View {
        Button(action: action) {
            label()
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(style.foregroundColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(style.backgroundColor)
                .clipShape(Capsule())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

extension CapsuleButton where Label == Text {
    init(
        _ title: String,
        style: Style = .primary,
        action: @escaping () -> Void
    ) {
        self.init(style: style, action: action) {
            Text(title)
        }
    }
}

struct CapsuleButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            CapsuleButton("电影", style: .secondary) {}
            CapsuleButton("豆瓣", style: .link) {}
            CapsuleButton("添加票据", style: .primary) {}
        }
        .padding()
        .background(Color(.systemBackground))
    }
}
