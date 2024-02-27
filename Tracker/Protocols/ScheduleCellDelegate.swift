//
//  ScheduleCellDelegate.swift
//  Tracker
//
//  Created by Игорь Мунгалов on 22.02.2024.
//

import UIKit

protocol ScheduleCellDelegate: AnyObject {
    func toggleWasSwitched(to isOn: Bool, for weekDay: WeekDay)
}
