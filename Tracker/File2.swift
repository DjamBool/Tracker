//
//import Foundation
//private func filterTrackersBySelectedDate() -> [TrackerCategory] {
//    var categoriesFromCoreData = [TrackerCategory]()/*= trackerCategoryStore.trackerCategories*/
//    
//   // let selectedWeekday = Calendar.current.component(.weekday, from: datePicker.date)
//    
//    var filteredCategories: [TrackerCategory] = []
//    var pinnedTrackers: [Tracker] = []
//    
//    for category in categoriesFromCoreData {
//        var newTrackers = [Tracker]()
//        for tracker in category.vi
//        let filteredTrackersForDate: [Tracker] = category.trackers.filter { tracker in
//            guard let schedule = tracker.schedule else { return false }
//            let days = schedule.map { $0.rawValue }
//            let day = days[selectedWeekday]
//            return tracker.schedule!.contains(WeekDay(rawValue: day) ?? .monday)
//        }
////                guard let schedule = self.tracker?.schedule else { continue }
////                let days = schedule.map { $0.numberValue }
////                if let day = currentDate, days.contains(day) {
////                   // return (tracker?.schedule?.contains(WeekDay(rawValue: days[] ?? .monday)))
////                    //tracker in
////                    //                guard let schedule = tracker.schedule else { continue }
////                    //                let scheduleIntegers = schedule.map { $0.numberValue }
////                    //                //if let day = currentDate, scheduleIntegers.contains(day) {
////                    //
////                    //                tracker.schedule?.contains(scheduleIntegers)
////                }
//            
//            let nonPinnedTrackersForDate = filteredTrackersForDate.filter { !$0.isPinned }
//            if !nonPinnedTrackersForDate.isEmpty {
//                filteredCategories.append(TrackerCategory(title: category.title, trackers: nonPinnedTrackersForDate))
//            }
//            let pinnedTrackersForDate = filteredTrackersForDate.filter { $0.isPinned }
//            pinnedTrackers.append(contentsOf: pinnedTrackersForDate)
//        }
//        
//        if !pinnedTrackers.isEmpty {
//            let pinnedCategory = TrackerCategory(title: "Fixed", trackers: pinnedTrackers)
//            filteredCategories.insert(pinnedCategory, at: 0)
//        }
//        
//        return filteredCategories
//    }
