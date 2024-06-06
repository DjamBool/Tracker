//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Игорь Мунгалов on 06.06.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    
    func testTrackersViewControllerLightMode() {
        let vc = TrackersViewController()
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testTrackersViewControllerDarkMode() {
        let vc = TrackersViewController()
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }

}
