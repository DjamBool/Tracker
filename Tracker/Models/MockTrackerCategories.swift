//
//  MockTrackerCategories.swift
//  Tracker
//
//  Created by Игорь Мунгалов on 15.12.2023.
//

import Foundation
import UIKit

 var mockCategories: [TrackerCategory] = [
    TrackerCategory(title: "Home",
                    trackers: [Tracker(id: UUID(),
                                       title: "Поливать растения",
                                       color: .colorSelection1,
                                       emoji: "🌺",
                                       schedule: [.tuesday, .saturday]),
                               Tracker(id: UUID(),
                                       title: "Накормить кошку",
                                       color: .colorSelection2,
                                       emoji: "🐈",
                                       schedule: [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday])
                    ]),
    TrackerCategory(title: "Увлечения",
                    trackers: [Tracker(id: UUID(),
                                       title: "Практикум",
                                       color: .colorSelection3,
                                       emoji: "💼",
                                       schedule: [.monday, .tuesday, .wednesday, .thursday, .friday])])]
