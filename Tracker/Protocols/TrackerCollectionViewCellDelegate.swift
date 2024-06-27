//
//  TrackerCollectionViewCellDelegate.swift
//  Tracker
//
//  Created by Игорь Мунгалов on 28.02.2024.
//

import UIKit

protocol TrackerCollectionViewCellDelegate: AnyObject {
    func pinTracker(at indexPath: IndexPath)
    //func pinTracker(id: UUID, at indexPath: IndexPath)
    //func unpinTracker(at indexPath: IndexPath)
   // func editTracker(id: UUID, at indexPath: IndexPath)
    func editTracker(at indexPath: IndexPath)
    //func deleteTracker(id: UUID, at indexPath: IndexPath)
    func deleteTracker(at indexPath: IndexPath)
    func completeTracker(id: UUID, at indexPath: IndexPath)
    func uncompleteTracker(id: UUID, at indexPath: IndexPath)
    
   // func getSelectedDate() -> Date
   // func competeTracker(id: UUID)
  //  func record(_ sender: Bool, _ cell: TrackersCollectionViewCell)
    //func isTrackerPinned(at indexPath: IndexPath) -> Bool
}
