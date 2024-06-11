
import Foundation

enum Filters: String, CaseIterable {
    case allTrackers = "Все трекеры"
    case completedTrackers = "Завершенные"
    case uncompletedTrackers = "Не завершенные"
    case trackersForToday = "Трекеры на сегодня"
}
