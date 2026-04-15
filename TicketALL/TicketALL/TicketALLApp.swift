import SwiftUI
import SwiftData

@main
struct TicketALLApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: [Ticket.self, Tag.self])
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        Text("首页")
                    }
                    .tag(0)
                
                ProfileView()
                    .tabItem {
                        Image(systemName: selectedTab == 1 ? "person.fill" : "person")
                        Text("我的")
                    }
                    .tag(1)
            }
            .accentColor(Color(red: 0.0, green: 0.48, blue: 1.0))
            
            GeometryReader { geometry in
                Color.clear
                    .frame(height: 56)
                    .background(
                        Color.clear
                    )
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("我的票根")
                                .font(.system(size: 18, weight: .semibold))
                            Text("收集美好回忆")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("我的收藏") {
                    LabeledContent("票据数量", value: "0")
                    LabeledContent("标签数量", value: "0")
                }
                
                Section("管理") {
                    NavigationLink("标签管理") {
                        Text("标签管理")
                            .navigationTitle("标签管理")
                    }
                    NavigationLink("票据类型") {
                        Text("票据类型")
                            .navigationTitle("票据类型")
                    }
                }
                
                Section {
                    NavigationLink("Mock 数据") {
                        MockDataView()
                    }
                }
            }
            .navigationTitle("我的")
        }
    }
}

struct MockDataView: View {
    var body: some View {
        List {
            Section {
                Button("加载 Mock 数据") {
                }
                Button("清除所有数据") {
                }
                .foregroundColor(.red)
            }
            
            Section("说明") {
                Text("Mock 数据包含多种类型的票据样本，用于测试瀑布流布局和分享功能。")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Mock 数据")
    }
}

#Preview {
    MainTabView()
}
