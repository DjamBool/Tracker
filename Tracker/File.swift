//
//
//import Foundation
//
//private func reloadVisibleCategories(with categories: [TrackerCategory]) {
//    var newCategories = [TrackerCategory]()
//    var pinnedTrackers: [Tracker] = []
// 
//    for category in categories {
//        var newTrackers = [Tracker]()
//        for tracker in category.visibleTrackers(filterString: searchText, pin: nil) {
//            guard let schedule = tracker.schedule else { continue }
//            let scheduleIntegers = schedule.map { $0.numberValue }
//            if let day = currentDate, scheduleIntegers.contains(day) &&
//                (
//                searchText.isEmpty ||
//                tracker.title.lowercased().contains(searchText.lowercased())
//            )
//            {
//                newTrackers.append(tracker)
//                
//                if selectedFilter == .completedTrackers {
//                   // filterNotFounded(filter: .completedTrackers)
//                    if !completedTrackers.contains(where: { record in
//                        record.id == tracker.id &&
//                        record.date == datePicker.date
//                    
//                    }) {
//                        continue
//                    }
//                }
//                if selectedFilter == .uncompletedTrackers {
//                    //filterNotFounded(filter: .completedTrackers)
//                   // filterNotCompletedTrackers(newCategories)
//                    if completedTrackers.contains(where: { record in
//                        record.id == tracker.id &&
//                        record.date == datePicker.date
//                    }) {
//                        continue
//                    }
//                   // newTrackers.append(tracker)
//                }
////                    if tracker.isPinned == true {
////                        pinnedTrackers.append(tracker)
////                    } else {
////                        newTrackers.append(tracker)
////                    }
//            }
//        }
//        
//        if newTrackers.count > 0 {
//            let newCategory = TrackerCategory(
//                title: category.title,
//                trackers: newTrackers
//            )
//            newCategories.append(newCategory)
//        }
//    }
//    visibleCategories = newCategories
//    self.pinnedTrackers = pinnedTrackers
//    collectionView.reloadData()
//    showNothingWasFoundView()
//    //updateNothingWasFoundView()
//}
//
