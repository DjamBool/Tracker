//
//  Tracker.swift
//  Tracker
//
//  Created by Игорь Мунгалов on 01.12.2023.
//

import Foundation
import UIKit

struct Tracker {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
   // let schedule: Date? //
    let schedule: [WeekDay]

}
