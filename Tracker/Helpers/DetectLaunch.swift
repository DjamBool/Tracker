//
//  DetectLaunch.swift
//  Tracker
//
//  Created by Игорь Мунгалов on 31.05.2024.
//

import Foundation
struct DetectLaunch {
static let keyforLaunch = "validateFirstlunch"
static var isFirst: Bool {
    get {
        return UserDefaults.standard.bool(forKey: keyforLaunch)
    }
    set {
        UserDefaults.standard.set(newValue, forKey: keyforLaunch)
    }
}
}
