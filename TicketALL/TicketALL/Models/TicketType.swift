import SwiftUI

enum TicketType: String, Codable, CaseIterable {
    case movie
    case concert
    case exhibition
    case theater
    case sports
    case custom
    
    var displayName: String {
        switch self {
        case .movie: return "电影"
        case .concert: return "演唱会"
        case .exhibition: return "展览"
        case .theater: return "话剧"
        case .sports: return "体育"
        case .custom: return "自定义"
        }
    }
    
    var iconName: String {
        switch self {
        case .movie: return "film"
        case .concert: return "music.mic"
        case .exhibition: return "photo.on.rectangle"
        case .theater: return "theatermasks"
        case .sports: return "sportscourt"
        case .custom: return "tag"
        }
    }
    
    var gradientColors: [Color] {
        switch self {
        case .movie:
            return [Color(red: 0.94, green: 0.58, blue: 0.98), Color(red: 0.96, green: 0.34, blue: 0.42)]
        case .concert:
            return [Color(red: 0.31, green: 0.67, blue: 1.0), Color(red: 0.0, green: 0.95, blue: 1.0)]
        case .exhibition:
            return [Color(red: 0.26, green: 0.91, blue: 0.48), Color(red: 0.22, green: 0.98, blue: 0.84)]
        case .theater:
            return [Color(red: 1.0, green: 0.76, blue: 0.03), Color(red: 1.0, green: 0.42, blue: 0.03)]
        case .sports:
            return [Color(red: 0.11, green: 0.73, blue: 0.62), Color(red: 0.09, green: 0.59, blue: 0.86)]
        case .custom:
            return [Color(red: 0.4, green: 0.4, blue: 0.4), Color(red: 0.25, green: 0.25, blue: 0.25)]
        }
    }
}
