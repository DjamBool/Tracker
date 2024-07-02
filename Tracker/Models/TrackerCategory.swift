
import Foundation

struct TrackerCategory {
    let title: String
    var trackers: [Tracker]
    
    func visibleTrackers(filterString: String) -> [Tracker] {
        if filterString.isEmpty {
            return  trackers
        } else {
            return trackers.filter { $0.title.lowercased().contains(filterString.lowercased()) } 
                
        }
    }
}
