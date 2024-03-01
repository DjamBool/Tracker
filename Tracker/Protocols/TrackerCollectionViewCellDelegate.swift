//
//  TrackerCollectionViewCellDelegate.swift
//  Tracker
//
//  Created by Игорь Мунгалов on 28.02.2024.
//

import UIKit

protocol TrackerCollectionViewCellDelegate: AnyObject {
    func competeTracker(id: UUID)
    func uncompleteTracker(id: UUID)
}
