

import UIKit

protocol TrackerCollectionViewCellDelegate: AnyObject {
    func pinTracker(at indexPath: IndexPath)
    func editTracker(at indexPath: IndexPath)
    func deleteTracker(at indexPath: IndexPath)
    func completeTracker(id: UUID, at indexPath: IndexPath)
    func uncompleteTracker(id: UUID, at indexPath: IndexPath)
}
