//
//  TrackerStore.swift
//  Tracker
//
//  Created by Игорь Мунгалов on 06.05.2024.
//

import UIKit
import CoreData

final class TrackerStore {
    static let shared = TrackerStore()
    private let context: NSManagedObjectContext
    private let uiColorMarshalling = UIColorMarshalling()
    
    convenience init() {
        let context = DataStore.shared.context
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    private func fetchTrackers() throws -> [Tracker] {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let trackersFromCoreData = try context.fetch(request)
        
        return try trackersFromCoreData.map { try self.convert(from: $0) }
    }
    
    private func convert(from tracker: TrackerCoreData) throws -> Tracker {
        let trackerColor = uiColorMarshalling.color(from: tracker.color ?? "")
        
        guard
            let id = tracker.id,
            let title = tracker.title,
            let color = trackerColor,
            let emoji = tracker.emoji,
            let schedule = tracker.schedule
        else {
            throw DataError.dataError
        }
        
        return Tracker(
            id: id,
            title: title,
            color: color,
            emoji: emoji,
            schedule: schedule.compactMap { WeekDay(rawValue: $0) }
        )
    }
    
    private func addNewTracker(_ tracker: Tracker) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        updateTracker(trackerCoreData, with: tracker)
        try saveContext()
    }
    
    private func updateTracker(_ trackerCoreData: TrackerCoreData, with tracker: Tracker) {
        let trackerColor = uiColorMarshalling.hexString(from: tracker.color)
        
        trackerCoreData.id = tracker.id
        trackerCoreData.title = tracker.title
        trackerCoreData.color = trackerColor
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = tracker.schedule?.compactMap { $0.rawValue }
    }
    
    private func saveContext() throws {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
    }
}
