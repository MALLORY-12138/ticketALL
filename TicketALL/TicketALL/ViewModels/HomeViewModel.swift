import SwiftUI
import SwiftData

@MainActor
@Observable
class HomeViewModel {
    var tickets: [Ticket] = []
    var filteredTickets: [Ticket] = []
    var selectedType: TicketType?
    var selectedTags: Set<UUID> = []
    var viewMode: ViewMode = .waterfall
    var isLoading = false
    
    enum ViewMode {
        case waterfall
        case list
    }
    
    init() {
        loadMockData()
    }
    
    func loadMockData() {
        tickets = Ticket.mockData
        filterTickets()
    }
    
    func filterTickets() {
        var result = tickets
        
        if let type = selectedType {
            result = result.filter { $0.type == type }
        }
        
        if !selectedTags.isEmpty {
            result = result.filter { ticket in
                !ticket.tags.filter { selectedTags.contains($0.id) }.isEmpty
            }
        }
        
        filteredTickets = result
    }
    
    func selectType(_ type: TicketType?) {
        selectedType = type
        filterTickets()
    }
    
    func toggleTag(_ tagId: UUID) {
        if selectedTags.contains(tagId) {
            selectedTags.remove(tagId)
        } else {
            selectedTags.insert(tagId)
        }
        filterTickets()
    }
    
    func toggleViewMode() {
        viewMode = viewMode == .waterfall ? .list : .waterfall
    }
    
    func clearFilters() {
        selectedType = nil
        selectedTags.removeAll()
        filterTickets()
    }
}
