import SwiftUI

struct TicketCardView: View {
    let ticket: Ticket
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ticketImageSection
            ticketInfoSection
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPressed)
    }
    
    private var ticketImageSection: some View {
        ZStack {
            if let image = ticket.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                LinearGradient(
                    gradient: Gradient(colors: ticket.type.gradientColors),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .overlay(
                    VStack(spacing: 12) {
                        Image(systemName: ticket.type.iconName)
                            .font(.system(size: 48))
                            .foregroundColor(.white.opacity(0.9))
                        Text(ticket.title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .padding(.horizontal, 20)
                        Text(formatDate(ticket.date))
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.85))
                    }
                )
            }
        }
        .frame(height: 200)
        .clipped()
    }
    
    private var ticketInfoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(ticket.title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1))
                .lineLimit(2)
            
            HStack(spacing: 8) {
                ticketTypeBadge
                
                Text(formatShortDate(ticket.date))
                    .font(.system(size: 11))
                    .foregroundColor(Color(white: 0.6))
            }
            
            if !ticket.relatedLinks.isEmpty {
                relatedLinksSection
            }
        }
        .padding(14)
    }
    
    private var ticketTypeBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: ticket.type.iconName)
                .font(.system(size: 12))
            Text(ticket.type.displayName)
                .font(.system(size: 11, weight: .medium))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(Color(white: 0.96))
        .clipShape(Capsule())
        .foregroundColor(Color(white: 0.4))
    }
    
    private var relatedLinksSection: some View {
        HStack(spacing: 8) {
            ForEach(Array(ticket.relatedURLs.prefix(2)), id: \.self) { url in
                Link(destination: url) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.right.square")
                            .font(.system(size: 10))
                        Text(linkDisplayName(for: url))
                            .font(.system(size: 10, weight: .medium))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color(red: 0.0, green: 0.48, blue: 1.0).opacity(0.1))
                    .clipShape(Capsule())
                    .foregroundColor(Color(red: 0.0, green: 0.48, blue: 1.0))
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
    
    private func formatShortDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日"
        return formatter.string(from: date)
    }
    
    private func linkDisplayName(for url: URL) -> String {
        if url.absoluteString.contains("douban.com") {
            return "豆瓣"
        } else if url.absoluteString.contains("maps.apple.com") {
            return "导航"
        } else {
            return "链接"
        }
    }
}

struct TicketCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TicketCardView(ticket: Ticket.mockData[0])
                .frame(width: 180)
                .previewLayout(.sizeThatFits)
                .padding()
                .background(Color(.systemGray6))
            
            HStack(spacing: 16) {
                TicketCardView(ticket: Ticket.mockData[0])
                    .frame(width: 170)
                TicketCardView(ticket: Ticket.mockData[1])
                    .frame(width: 170)
            }
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color(.systemGray6))
        }
    }
}
