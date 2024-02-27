//
//  File.swift
//  Tracker
//
//  Created by Игорь Мунгалов on 22.02.2024.
//

import UIKit

protocol TrackersDelegate: AnyObject{
    //func addTracker(title: String, tracker: Tracker)
    func addedNew(tracker: Tracker)

}
