

import UIKit

protocol TrackersDelegate: AnyObject{
    func addedNew(tracker: Tracker, categoryTitle: String)
    func didEditTracker(_ tracker: Tracker) 
}
