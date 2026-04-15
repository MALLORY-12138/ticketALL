import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var showingFilter = false
    @State private var selectedTicket: Ticket?
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color(red: 0.95, green: 0.95, blue: 0.97)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerSection
                    
                    if viewModel.filteredTickets.isEmpty {
                        emptyStateView
                    } else {
                        contentSection
                    }
                }
                .padding(.bottom, 83)
                
                FloatingActionButton(action: {
                })
            }
            .sheet(isPresented: $showingFilter) {
                FilterView(viewModel: viewModel)
            }
            .sheet(item: $selectedTicket) { ticket in
                TicketDetailView(ticket: ticket)
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            Text("我的票根")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.black)
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: {
                    viewModel.toggleViewMode()
                }) {
                    Image(systemName: viewModel.viewMode == .waterfall ? "square.grid.2x2" : "list.bullet")
                        .font(.system(size: 20))
                        .foregroundColor(.primary)
                }
                
                Button(action: {
                    showingFilter = true
                }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.system(size: 20))
                        .foregroundColor(.primary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 16)
    }
    
    private var contentSection: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.filteredTickets) { ticket in
                    Button(action: {
                        selectedTicket = ticket
                    }) {
                        TicketCardView(ticket: ticket)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "ticket")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.4))
            Text("还没有票根")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.gray)
            Text("点击下方 + 按钮添加你的第一张票根")
                .font(.system(size: 14))
                .foregroundColor(.gray.opacity(0.7))
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct FloatingActionButton: View {
    let action: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: action) {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.0, green: 0.48, blue: 1.0),
                            Color(red: 0.35, green: 0.34, blue: 0.84)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }
                .frame(width: 56, height: 56)
                .clipShape(Capsule())
                .shadow(
                    color: Color(red: 0.0, green: 0.48, blue: 1.0).opacity(0.4),
                    radius: 20,
                    x: 0,
                    y: 4
                )
            }
            .padding(.bottom, 90)
        }
    }
}

struct FilterView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("票据类型") {
                    ForEach(TicketType.allCases, id: \.self) { type in
                        Button(action: {
                            viewModel.selectType(viewModel.selectedType == type ? nil : type)
                        }) {
                            HStack {
                                Label(type.displayName, systemImage: type.iconName)
                                Spacer()
                                if viewModel.selectedType == type {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
                
                if viewModel.selectedType != nil || !viewModel.selectedTags.isEmpty {
                    Section {
                        Button("清除筛选") {
                            viewModel.clearFilters()
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("筛选")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct TicketDetailView: View {
    let ticket: Ticket
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let image = ticket.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
                    } else {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: ticket.type.gradientColors),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .aspectRatio(3/4, contentMode: .fit)
                            .cornerRadius(16)
                            .overlay(
                                VStack(spacing: 16) {
                                    Image(systemName: ticket.type.iconName)
                                        .font(.system(size: 60))
                                        .foregroundColor(.white.opacity(0.9))
                                    Text(ticket.title)
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(ticket.title)
                                .font(.system(size: 24, weight: .bold))
                            
                            HStack {
                                CapsuleButton(ticket.type.displayName, style: .secondary) {}
                                    .disabled(true)
                                
                                Text(ticket.date.formatted(date: .long, time: .omitted))
                                    .font(.system(size: 16))
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        if let venue = ticket.venue {
                            InfoRow(icon: "mappin.and.ellipse", title: "场馆", value: venue)
                        }
                        
                        if let seat = ticket.seat {
                            InfoRow(icon: "chair", title: "座位", value: seat)
                        }
                        
                        if let price = ticket.price {
                            InfoRow(icon: "yensign.circle", title: "价格", value: "¥\(String(format: "%.2f", price))")
                        }
                        
                        if !ticket.relatedLinks.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("相关链接")
                                    .font(.system(size: 16, weight: .semibold))
                                
                                ForEach(ticket.relatedURLs, id: \.self) { url in
                                    Link(destination: url) {
                                        HStack {
                                            Image(systemName: "arrow.up.right.square")
                                            Text(url.absoluteString)
                                                .lineLimit(1)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                        }
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(12)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
                .padding()
            }
            .navigationTitle("票据详情")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("关闭") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    ShareLink(item: ticket.title) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.blue)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.system(size: 16))
            }
            
            Spacer()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
