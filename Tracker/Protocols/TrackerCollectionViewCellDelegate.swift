//
//  TrackerCollectionViewCellDelegate.swift
//  Tracker
//
//  Created by Игорь Мунгалов on 28.02.2024.
//

import UIKit

protocol TrackerCollectionViewCellDelegate: AnyObject {
    func pinTracker(id: UUID, at indexPath: IndexPath)
    func editTracker(id: UUID, at indexPath: IndexPath)
    func deleteTracker(id: UUID, at indexPath: IndexPath)
    
    func completeTracker(id: UUID, at indexPath: IndexPath)
    func uncompleteTracker(id: UUID, at indexPath: IndexPath)
    
    func getSelectedDate() -> Date
   // func competeTracker(id: UUID)
}
