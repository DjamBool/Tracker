
import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func daysWereChosen(_ selectedDays: [WeekDay])
}
