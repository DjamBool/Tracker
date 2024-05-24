
import Foundation

protocol CategoriesViewModelDelegate: AnyObject {
    func didSelectCategory(category: TrackerCategory)
}

final class CategoriesViewModel {
    
    typealias Binding<T> = (T) -> Void
    
    var updateClosure: (() -> Void)?
    
    
    private(set) var selectedCategory: TrackerCategory?
    private let trackerCategoryStore = TrackerCategoryStore.shared
    private weak var delegate: CategoriesViewModelDelegate?
    
    private(set) var categories = [TrackerCategory]() {
        didSet {
            updateClosure?()
        }
    }
    
    var tableViewIsHidden: Bool {
        return categories.isEmpty
    }
    
    init(
        selectedCategory: TrackerCategory?,
        delegate: CategoriesViewModelDelegate?
    ) {
        self.selectedCategory = selectedCategory
        self.delegate = delegate
        
        trackerCategoryStore.delegate = self
        categories = trackerCategoryStore.trackerCategories
    }
    
    func selectCategory(with title: String) {
        let category = TrackerCategory(title: title, trackers: [])
        delegate?.didSelectCategory(category: category)
    }
    
    func selectedCategory(_ category: TrackerCategory) {
        selectedCategory = category
        delegate?.didSelectCategory(category: category)
        updateClosure?()
    }
}

// MARK: - TrackerCategoryStoreDelegate

extension CategoriesViewModel: TrackerCategoryStoreDelegate {
    func store(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate) {
        print(#function, "CategoriesViewModel")
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.categories = trackerCategoryStore.trackerCategories
        }
    }
}
