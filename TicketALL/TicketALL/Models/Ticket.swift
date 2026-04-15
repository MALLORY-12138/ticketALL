import SwiftUI
import SwiftData

@Model
final class Ticket {
    var id: UUID
    var title: String
    var type: TicketType
    var date: Date
    var venue: String?
    var seat: String?
    var price: Double?
    var imageData: Data?
    var originalImageData: Data?
    var relatedLinks: [String]
    var createdAt: Date
    
    @Relationship(deleteRule: .cascade)
    var tags: [Tag] = []
    
    init(
        id: UUID = UUID(),
        title: String,
        type: TicketType,
        date: Date,
        venue: String? = nil,
        seat: String? = nil,
        price: Double? = nil,
        imageData: Data? = nil,
        originalImageData: Data? = nil,
        relatedLinks: [String] = [],
        tags: [Tag] = [],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.type = type
        self.date = date
        self.venue = venue
        self.seat = seat
        self.price = price
        self.imageData = imageData
        self.originalImageData = originalImageData
        self.relatedLinks = relatedLinks
        self.tags = tags
        self.createdAt = createdAt
    }
    
    var image: Image? {
        guard let imageData = imageData, let uiImage = UIImage(data: imageData) else {
            return nil
        }
        return Image(uiImage: uiImage)
    }
    
    var originalImage: Image? {
        guard let imageData = originalImageData, let uiImage = UIImage(data: imageData) else {
            return nil
        }
        return Image(uiImage: uiImage)
    }
    
    var relatedURLs: [URL] {
        relatedLinks.compactMap { URL(string: $0) }
    }
}

extension Ticket {
    static var mockData: [Ticket] {
        let calendar = Calendar.current
        let date1 = calendar.date(byAdding: .day, value: -5, to: Date())!
        let date2 = calendar.date(byAdding: .day, value: -10, to: Date())!
        let date3 = calendar.date(byAdding: .day, value: -15, to: Date())!
        
        return [
            Ticket(
                title: "星际穿越 - 重映版 IMAX",
                type: .movie,
                date: date1,
                venue: "万达影城 CBD 店",
                seat: "8排 15座",
                price: 89.0,
                relatedLinks: [
                    "https://movie.douban.com/subject/1889243/",
                    "https://maps.apple.com/?q=万达影城CBD店"
                ],
                tags: []
            ),
            Ticket(
                title: "五月天 - 人生无限公司 北京站",
                type: .concert,
                date: date2,
                venue: "国家体育场（鸟巢）",
                seat: "C区 23排 45座",
                price: 1280.0,
                relatedLinks: [],
                tags: []
            ),
            Ticket(
                title: "莫奈与印象派大师展",
                type: .exhibition,
                date: date3,
                venue: "上海外滩1号",
                seat: nil,
                price: 188.0,
                relatedLinks: [
                    "https://www.example.com/exhibition"
                ],
                tags: []
            )
        ]
    }
}
