//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Игорь Мунгалов on 06.05.2024.
//

import UIKit
import CoreData

final class TrackerRecordStore: NSObject {
    static let shared = TrackerRecordStore()
    private let context: NSManagedObjectContext
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addNewTracker(_ trackerRecord: TrackerRecord) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)

        trackerRecordCoreData.id = trackerRecord.id
        trackerRecordCoreData.date = trackerRecord.date

        try context.save()
    }
    
    func deleteTrackerRecord(_ trackerRecord: TrackerRecord) throws {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "id == %@ AND date == %@", trackerRecord.id as CVarArg, trackerRecord.date as CVarArg)

        if let existingRecord = try context.fetch(request).first {
            context.delete(existingRecord)
            try context.save()
        }
    }
    
    func trackerRecord(from trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard
            let id = trackerRecordCoreData.id,
            let date = trackerRecordCoreData.date
        else { throw DataError.dataError }

        return TrackerRecord(
            id: id,
            date: date
        )
    }
    
    func fetchTrackerRecords() throws -> [TrackerRecord] {
        let request = TrackerRecordCoreData.fetchRequest()
        let trackerRecordFromCoreData = try context.fetch(request)

        return try trackerRecordFromCoreData.map { try self.trackerRecord(from: $0) }
    }
}
