
import UIKit
import CoreData

protocol TrackerRecordStoreDelegate: AnyObject {
    func store(_ store: TrackerRecordStore, didUpdate update: TrackerRecordStoreUpdate)
}

struct TrackerRecordStoreUpdate {
    struct Move: Hashable {
        let oldIndex: Int
        let newIndex: Int
    }
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
    let movedIndexes: Set<Move>
}

// MARK: - TrackerRecordStore

final class TrackerRecordStore: NSObject {
    static let shared = TrackerRecordStore()
    private let context: NSManagedObjectContext
    
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>!
    
    weak var delegate: TrackerRecordStoreDelegate?
    
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    private var movedIndexes: Set<TrackerRecordStoreUpdate.Move>?
    
    var trackerRecords: [TrackerRecord] {
        guard let objects = self.fetchedResultsController.fetchedObjects,
              let records = try? objects.map ({
                  try self.trackerRecord(from: $0)
              })
        else { return [] }

        return records
    }
    
    convenience override init() {
        let context = DataStore.shared.context
        self.init(context: context)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            assertionFailure("fetchedResultsController.performFetch() failed")
        }
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        
        let request = TrackerRecordCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerRecordCoreData.date, ascending: true)]
        
        let controller = NSFetchedResultsController(fetchRequest: request,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        
        controller.delegate = self
        self.fetchedResultsController = controller
    }
    
     func addNewTracker(_ trackerRecord: TrackerRecord) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)

        trackerRecordCoreData.id = trackerRecord.id
        trackerRecordCoreData.date = trackerRecord.date

        try context.save()
    }
    
    private func trackerRecord(from trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard
            let id = trackerRecordCoreData.id,
            let date = trackerRecordCoreData.date
        else { throw DataError.dataError }

        return TrackerRecord(
            id: id,
            date: date
        )
    }

    func update() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("TrackerRecordStore update error: \(error)")
        }
    }
    
    func deleteTrackerRecord(with id: UUID, date: Date) throws {
        let record = fetchedResultsController.fetchedObjects?.first {
            $0.id == id &&
            $0.date == date
        }

        if let record = record {
            context.delete(record)
            try context.save()
        }
        update()
    }
    
    func deleteTrackerRecord(trackerRecord: TrackerRecord) throws {
        guard let record = fetchedResultsController?.fetchedObjects?.first(where: {
            $0.id == trackerRecord.id && $0.date == trackerRecord.date
        }) else { return }
        context.delete(record)
        do {
            try context.save()
        } catch {
            throw DataError.decodingError
        }
    }

    
    
    func deleteAllTrackerRecords(with trackerID: UUID) throws {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "id == %@", trackerID as CVarArg)
        do {
            let allRecords = try context.fetch(request)
            for record in allRecords {
                context.delete(record)
            }
            try context.save()
        } catch {
            throw error
        }
    }
    
    func fetchRecords() throws -> Set<TrackerRecord> {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        do {
            let trackerRecordCoreDataArray = try context.fetch(fetchRequest)
            let trackerRecords = trackerRecordCoreDataArray.map { trackerRecordCoreData in
                return TrackerRecord(
                    id: trackerRecordCoreData.id ?? UUID(),
                    date: trackerRecordCoreData.date ?? Date()
                )
            }
            return Set(trackerRecords)
        } catch {
            throw DataError.decodingError
        }
    }
}


extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
        updatedIndexes = IndexSet()
        movedIndexes = Set<TrackerRecordStoreUpdate.Move>()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard
            let insertedIndexes,
            let deletedIndexes,
            let updatedIndexes,
            let movedIndexes
        else { return }

        delegate?.store(
            self,
            didUpdate: TrackerRecordStoreUpdate(
                insertedIndexes: insertedIndexes,
                deletedIndexes: deletedIndexes,
                updatedIndexes: updatedIndexes,
                movedIndexes: movedIndexes
            )
        )
        self.insertedIndexes = nil
        self.deletedIndexes = nil
        self.updatedIndexes = nil
        self.movedIndexes = nil
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath else { return }
            deletedIndexes?.insert(indexPath.item)
        case.insert:
            guard let indexPath = newIndexPath else { return }
            insertedIndexes?.insert(indexPath.item)
        case .update:
            guard let indexPath else { return }
            updatedIndexes?.insert(indexPath.item)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { return }
            movedIndexes?.insert(.init(oldIndex: oldIndexPath.item, newIndex: newIndexPath.item))
        default:
            break
        }
    }
}
