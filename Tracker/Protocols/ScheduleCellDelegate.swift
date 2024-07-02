
import UIKit

protocol ScheduleCellDelegate: AnyObject {
    func toggleWasSwitched(to isOn: Bool, for weekDay: WeekDay)
}
