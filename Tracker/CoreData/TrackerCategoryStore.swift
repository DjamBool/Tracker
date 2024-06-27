
import UIKit
import CoreData

struct TrackerCategoryStoreUpdate {
    struct Move: Hashable {
        let oldIndex: Int
        let newIndex: Int
    }
    
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
    let movedIndexes: Set<Move>
}

protocol TrackerCategoryStoreDelegate: AnyObject {
    func store(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate)
}

// MARK: - TrackerCategoryStore

final class TrackerCategoryStore: NSObject {
    static let shared = TrackerCategoryStore()
    private let context: NSManagedObjectContext
    private let uiColorMarshalling = UIColorMarshalling()
    weak var delegate: TrackerCategoryStoreDelegate?
    
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    private var movedIndexes: Set<TrackerCategoryStoreUpdate.Move>?
    
    private let trackerStore = TrackerStore.shared
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)
        ]
        let fetchedResultsController =  NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        
        return fetchedResultsController
    }()
    
    convenience override init() {
        let context = DataStore.shared.context
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    var trackerCategories: [TrackerCategory] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let trackerCategories = try? objects.map({
                try self.trackerCategory(from: $0)
            }) else { return [] }
        
        return trackerCategories
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
    
    func category(_ categoryTitle: String) -> TrackerCategoryCoreData? {
        return fetchedResultsController.fetchedObjects?.first {
            $0.title == categoryTitle
        }
    }
    
    func updateCategoryTitle(_ newCategoryTitle: String, _ categoryToEdit: TrackerCategory) throws {
        let category = fetchedResultsController.fetchedObjects?.first {
            $0.title == categoryToEdit.title
        }
        category?.title = newCategoryTitle
        try context.save()
    }
    
    func category(forTracker tracker: Tracker) -> TrackerCategory? {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "ANY trackers.id == %@", tracker.id.uuidString)
        guard let trackerCategoriesCoreData = try? context.fetch(request) else { return nil }
        guard let categories = try? trackerCategoriesCoreData.map({ try self.trackerCategory(from: $0)})
        else { return nil }
        return categories.first
    }
    
    
    func deleteCategory(
        _ categoryToDelete: TrackerCategory)
    throws {
        let category = fetchedResultsController.fetchedObjects?.first {
            $0.title == categoryToDelete.title
        }
        if let category = category {
            context.delete(category)
            try context.save()
        }
    }
    
    func deleteTrackerFromCategory(tracker: Tracker, from categoryTitle: String) throws {
        guard let category = category(categoryTitle) else { return }
        var currentTrackers = category.trackers?.allObjects as? [TrackerCoreData] ?? []
        if let index = currentTrackers.firstIndex(where: { $0.id == tracker.id }) {
            currentTrackers.remove(at: index)
            category.trackers = NSSet(array: currentTrackers)
            do {
                try context.save()
            } catch {
                throw DataError.decodingError
            }
        }
    }
    
    private func trackerCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let category = trackerCategoryCoreData.title else {
            throw DataError.decodingError
        }
        
        let trackers: [Tracker] = trackerCategoryCoreData.trackers?.compactMap { tracker in
            guard let trackerCoreData = tracker as? TrackerCoreData else { return nil }
            let trackerCoreDataColor = uiColorMarshalling.color(from: trackerCoreData.color ?? "")
            
            guard
                let id = trackerCoreData.id,
                let title = trackerCoreData.title,
                let color = trackerCoreDataColor,
                let emoji = trackerCoreData.emoji,
                    let schedule = trackerCoreData.schedule
            else { return nil }
            
            let isPinned = trackerCoreData.isPinned
            
            return Tracker(
                id: id,
                title: title,
                color: color,
                emoji: emoji,
                schedule: schedule.compactMap { WeekDay(rawValue: $0) }, //trackerCoreData.schedule.compactMap { WeekDay(rawValue: $0) },
                isPinned: isPinned
            )
        } ?? []
        
        return TrackerCategory(
            title: category,
            trackers: trackers
        )
    }
    
    func addNewCategory( _ categoryName: TrackerCategory) throws {
        guard let trackerCategoryCoreData = NSEntityDescription.entity(forEntityName: "TrackerCategoryCoreData", in: context) else { return }

        if try context.fetch(TrackerCategoryCoreData.fetchRequest()).contains(where: { $0.title == categoryName.title }) {
            print("Category already exists: \(categoryName.title)")
            return
        }
        
        let newCategory = TrackerCategoryCoreData(entity: trackerCategoryCoreData, insertInto: context)
        newCategory.title = categoryName.title
        newCategory.trackers = []
        
       try saveContext()
    }
    
    func addNewTrackerCategory(_ trackerCategory: TrackerCategory) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        
        trackerCategoryCoreData.title = trackerCategory.title
        
        for tracker in trackerCategory.trackers {
            let trackerCoreData = TrackerCoreData(context: context)
            let trackerColor = uiColorMarshalling.hexString(from: tracker.color)
            
            trackerCoreData.id = tracker.id
            trackerCoreData.title = tracker.title
            trackerCoreData.color = trackerColor
            trackerCoreData.emoji = tracker.emoji
            trackerCoreData.schedule = tracker.schedule.compactMap { $0.rawValue }
            
            trackerCategoryCoreData.addToTrackers(trackerCoreData)
        }
        try context.save()
    }
    
    func addTrackerToCategory(_ tracker: Tracker, to trackerCategory: TrackerCategory) throws {
        let category = fetchedResultsController.fetchedObjects?.first {
            $0.title == trackerCategory.title
        }
        
        let trackerCoreData = TrackerCoreData(context: context)
        let trackerColor = uiColorMarshalling.hexString(from: tracker.color)
        
        trackerCoreData.id = tracker.id
        trackerCoreData.title = tracker.title
        trackerCoreData.color = trackerColor
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = tracker.schedule.compactMap { $0.rawValue }
        
        category?.addToTrackers(trackerCoreData)
        try context.save()
    }
    
    func addNewTrackerToCategory(_ tracker: Tracker, to trackerCategory: String) throws {
        let newTrackerCoreData = try trackerStore.fetchTrackerCoreData()
        guard let currentCategory = category(trackerCategory) else { return }
        var currentTrackers = currentCategory.trackers?.allObjects as? [TrackerCoreData] ?? []
        if let index = newTrackerCoreData.firstIndex(where: {$0.id == tracker.id}) {
            currentTrackers.append(newTrackerCoreData[index])
        }
        currentCategory.trackers = NSSet(array: currentTrackers)
        do {
            try context.save()
        } catch {
            throw DataError.decodingError
        }
    }
    
    func predicateFetch(trackerTitle: String) -> [TrackerCategory] {
        if trackerTitle.isEmpty {
            return trackerCategories
        } else {
            let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "ANY trackers.title CONTAINS[cd] %@", trackerTitle)
            
            guard let trackerCategoryCoreData = try? context.fetch(request)
            else { return [] }
            
            guard let categories = try? trackerCategoryCoreData.map({ try
                self.trackerCategory(from: $0)
            }) else { return [] }
            
            return categories
        }
    }
    
    func fetchCategories() throws -> [TrackerCategoryCoreData] {
        do {
            let categories = try context.fetch(NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData"))
            return categories
        } catch {
            throw DataError.decodingError
        }
    }
    
    func updateTrackerCategory(_ category: TrackerCategoryCoreData) -> TrackerCategory? {
        guard let newTitle = category.title else { return nil }
        guard let trackers = category.trackers else { return nil }
        return TrackerCategory(title: newTitle, trackers: trackers.compactMap { coreDataTracker -> Tracker? in
            if let coreDataTracker = coreDataTracker as? TrackerCoreData {
                return trackerStore.convertTrackers(from: coreDataTracker)
            }
            return nil
        })
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
        updatedIndexes = IndexSet()
        movedIndexes = Set<TrackerCategoryStoreUpdate.Move>()
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
            didUpdate: TrackerCategoryStoreUpdate(
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
