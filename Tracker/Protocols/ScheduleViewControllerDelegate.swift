//
//  ScheduleViewControllerDelegate.swift
//  Tracker
//
//  Created by Игорь Мунгалов on 22.02.2024.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func daysWereChosen(_ selectedDays: [WeekDay])
}
