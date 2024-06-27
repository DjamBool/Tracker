
import UIKit

class TackersVC: UIViewController {
    
    var tracker: Tracker? = nil
    
    private let filterButtonTitle = NSLocalizedString("filterButtonTitleText", comment: "")
    
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate: Int?
    private var todaysDate: Date = Date()
    private var searchText: String = ""
    
    private let trackerCategoryStore = TrackerCategoryStore.shared
    private let trackerRecordStore = TrackerRecordStore.shared
    private let trackerStore = TrackerStore.shared
    
    private let colors = Colors()
    private var dataStore = DataStore.shared
    
    weak var statisticDelegate: StatisticViewControllerDelegate?
    weak var trackerCreationScreenViewControllerDelegate: TrackerCreationScreenViewControllerDelegate?
    
    private var selectedFilter: Filters = .allTrackers
    private var selectedWeekDay: WeekDay = .monday
    private var pinnedTrackers: [Tracker] = []
    private var trackers = [Tracker]()
    private var originalCategories: [UUID: String] = [:]
    
    //analyticsService
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    private var navBarTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("navBarTitleLabelText", comment: "")
        label.textColor = .ypBlack
        label.font = UIFont.boldSystemFont(ofSize: 34)
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.clipsToBounds = true
        datePicker.layer.cornerRadius = 10
        datePicker.setValue(UIColor.ypWhite, forKey: "textColor")
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_Ru")
        datePicker.tintColor = .colorSelection3
        NSLayoutConstraint.activate([
            datePicker.widthAnchor.constraint(equalToConstant: 100)])
        datePicker.addTarget(self,
                             action: #selector(dateChanged),
                             for: .valueChanged)
        return datePicker
    }()
    
    private lazy var searchTextField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Поиск"
        textField.backgroundColor = colors.viewColor
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.delegate = self
        return textField
    }()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: TrackersCollectionViewCell.identifier)
        
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var whatWillWeTrackView: WhatWillWeTrackView = {
        let view = WhatWillWeTrackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nothingWasFoundView: NothingWasFoundView = {
        let view = NothingWasFoundView()
        view.isHidden = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.ypBlue
        button.setTitle(filterButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17,
                                                    weight: .regular)
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 16
        
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        //        reloadVisibleCategories(with: trackerCategoryStore.trackerCategories)
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  setWeekDay()
        //        makeAddTrackerButton()
        //        setupRightBarButtonItem()
        configureNavigationBar()
        layoutSubviews()
        
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        
        //        trackerCategoryStore.delegate = self
        //        trackerRecordStore.delegate = self
        //        trackerStore.delegate = self
        
        // completedTrackers = trackerRecordStore.trackerRecords
        syncData()
        //showNothingWasFoundView()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = navBarTitleLabel.text
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self, action: #selector(addtapped))
        addButton.tintColor = colors.textColor
        navigationItem.leftBarButtonItem = addButton
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    //    private func makeAddTrackerButton() {
    //
    //    }
    
    //    private func setupRightBarButtonItem() {
    //
    //    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func addtapped() {
        let trackerСreatingViewController = TrackerCreatingViewController()
        trackerСreatingViewController.delegate = self
        present(trackerСreatingViewController, animated: true)
    }
    
    @objc func dateChanged(sender: UIDatePicker) {
        //        let components = Calendar.current.dateComponents([.weekday], from: sender.date)
        //        if let day = components.weekday {
        //            currentDate = day
        //            reloadVisibleCategories(with: trackerCategoryStore.trackerCategories)
        //        }
        todaysDate = sender.date
        filteredTrackers()
        useFilter()
        showNothingWasFoundView()
    }
    
    @objc func filterButtonTapped(sender: AnyObject) {
        
        let viewController = FiltersViewController()
        viewController.selectedFilter = selectedFilter
        viewController.delegate = self
        let navController = UINavigationController(rootViewController: viewController)
        self.present(navController, animated: true)
    }
    
    //    private func setWeekDay() {
    //        let components = Calendar.current.dateComponents([.weekday], from: Date())
    //        currentDate = components.weekday
    //        print("\(String(describing: currentDate))")
    //    }
    
    //    private func reloadVisibleCategories(with categories: [TrackerCategory]) {
    //        var newCategories = [TrackerCategory]()
    //        var pinnedTrackers: [Tracker] = []
    //
    //        for category in categories {
    //            var filteredtrackers = [Tracker]()
    //            var newTrackers = [Tracker]()
    //            for tracker in category.visibleTrackers(filterString: searchText, pin: nil) {
    //                let schedule = tracker.schedule
    //                let scheduleIntegers = schedule.map { $0.numberValue }
    //                if let day = currentDate, scheduleIntegers.contains(day) &&
    //                    (
    //                    searchText.isEmpty ||
    //                    tracker.title.lowercased().contains(searchText.lowercased())
    //                )
    //                {
    //                    newTrackers.append(tracker)
    //
    //
    //                    if selectedFilter == .completedTrackers {
    //                       // filterNotFounded(filter: .completedTrackers)
    //                        if completedTrackers.contains(where: { record in
    //                            record.id == tracker.id &&
    //                            record.date == datePicker.date
    //
    //                        }) {
    //                            continue
    //                        }
    //                    }
    //                    if selectedFilter == .uncompletedTrackers {
    //                        //filterNotFounded(filter: .completedTrackers)
    //                       // filterNotCompletedTrackers(newCategories)
    //                        if !completedTrackers.contains(where: { record in
    //                            record.id == tracker.id &&
    //                            record.date == datePicker.date
    //                        }) {
    //                            continue
    //                        }
    //                       // newTrackers.append(tracker)
    //                    }
    ////                    if tracker.isPinned == true {
    ////                        pinnedTrackers.append(tracker)
    ////                    } else {
    ////                        newTrackers.append(tracker)
    ////                    }
    //                }
    //            }
    //
    //            if newTrackers.count > 0 {
    //                let newCategory = TrackerCategory(
    //                    title: category.title,
    //                    trackers: newTrackers
    //                )
    //                newCategories.append(newCategory)
    //            }
    //        }
    //        visibleCategories = newCategories
    //        self.pinnedTrackers = pinnedTrackers
    //        collectionView.reloadData()
    //        showNothingWasFoundView()
    //        //updateNothingWasFoundView()
    //    }
    
    private func showNothingWasFoundView() {
        if visibleCategories.isEmpty {
            nothingWasFoundView.isHidden = false
           
        } else {
            nothingWasFoundView.isHidden = true
            collectionView.reloadData()
        }
    }
    
    
    private func filterNotFounded(filter: Filters) {
        var isNotFounded = false
        if selectedFilter == filter {
            isNotFounded = true
        }
        
        if isNotFounded {
            nothingWasFoundView.isHidden = false
        }
    }
    
    private func layoutSubviews() {
        view.backgroundColor = colors.viewBackgroundColor
        
        [searchTextField, collectionView, whatWillWeTrackView,
         nothingWasFoundView, filterButton].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            
            searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 36),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            whatWillWeTrackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            whatWillWeTrackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            whatWillWeTrackView.topAnchor.constraint(equalTo: view.topAnchor),
            whatWillWeTrackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            nothingWasFoundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nothingWasFoundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            nothingWasFoundView.topAnchor.constraint(equalTo: view.topAnchor),
            nothingWasFoundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension TackersVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if visibleCategories.isEmpty {
            whatWillWeTrackView.isHidden = false
        }
        else {
            whatWillWeTrackView.isHidden = !visibleCategories.isEmpty
        }
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackersCollectionViewCell.identifier, for: indexPath) as? TrackersCollectionViewCell else { assertionFailure("Error in converting to a TrackersCollectionViewCell")
            return UICollectionViewCell()
        }
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        
        //Контекстное меню
        cell.delegate = self
        
        let isCompletedToday = isTrackerCompletedToday (id: tracker.id)
        let completedDays = completedTrackers.filter { $0.id == tracker.id }.count
        // let isEnabled = datePicker.date < Date() || Date() == datePicker.date
        //        cell.configureCell(tracker.id,
        //                           title: tracker.title,
        //                           color: tracker.color,
        //                           emoji: tracker.emoji,
        //                           isCompleted: isCompletedToday,
        //                           isEnabled: isEnabled,
        //                           completedDays: completedDays,
        //                           isPinned: tracker.isPinned ?? false )
        cell.configureCell(with: tracker,
                           isCompleted: isCompletedToday,
                           completedDays: completedDays,
                           indexPath: indexPath)//,
                          // isPined: tracker.isPinned)
        return cell
    }
    
    private func isTrackerCompletedToday (id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            isSameTracker(trackerRecord: trackerRecord, id: id)
        }
    }
    
    private func isSameTracker(trackerRecord: TrackerRecord, id: UUID) -> Bool {
        let isSameDay = Calendar.current.isDate(trackerRecord.date,
                                                inSameDayAs: datePicker.date)
        return trackerRecord.id == id && isSameDay
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HeaderView.identifier,
            for: indexPath) as? HeaderView else { fatalError("Error in converting to a HeaderView")
        }
        let categoryForSection = visibleCategories[indexPath.section]
        headerView.configureHeader(with: categoryForSection)
        return headerView
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TackersVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let interItemSpacing: CGFloat = 10
        let height: CGFloat = 148
        let width = (collectionView.bounds.width - interItemSpacing) / 2
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12,
                            left: 0,
                            bottom: 0,
                            right: 0)
    }
}

// MARK: - TrackersDelegate

extension TackersVC: TrackersDelegate {
    func addedNew(tracker: Tracker, categoryTitle: String) {
        var updatedCategory: TrackerCategory?
        let categories: [TrackerCategory] = trackerCategoryStore.trackerCategories
        
        for item in 0..<categories.count {
            if categories[item].title == categoryTitle {
                updatedCategory = categories[item]
            }
        }
        
        if updatedCategory != nil {
            try? trackerCategoryStore.addTrackerToCategory(tracker, to: updatedCategory ?? TrackerCategory(
                title: categoryTitle,
                trackers: [tracker]
            ))
        } else {
            let trackerCategory = TrackerCategory(
                title: categoryTitle,
                trackers: [tracker]
            )
            updatedCategory = trackerCategory
            try? trackerCategoryStore.addNewTrackerCategory(updatedCategory ?? TrackerCategory(
                title: categoryTitle,
                trackers: [tracker]
            ))
        }
        collectionView.reloadData()
        dismiss(animated: true)
        //   reloadVisibleCategories(with: trackerCategoryStore.trackerCategories)
    }
}

// MARK: -TrackerCollectionViewCellDelegate

// Контекстное меню!

extension TackersVC: TrackerCollectionViewCellDelegate {
    func pinTracker(at indexPath: IndexPath) {
        print(#function)
    }
    
    func deleteTracker(at indexPath: IndexPath) {
        print(#function)
    }
    
    func completeTracker(id: UUID, at indexPath: IndexPath) {
        if todaysDate <= Date() {
            let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
            completedTrackers.insert(trackerRecord)
            createRecord(record: trackerRecord)
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        if let trackerRecordToDelete = completedTrackers.first(where: { $0.id == id }) {
            completedTrackers.remove(trackerRecordToDelete)
            deleteRecord(record: trackerRecordToDelete)
            
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
//    func pinTracker(at indexPath: IndexPath) {
//        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
//        let currentCategory = visibleCategories[indexPath.section].title
//
//        if currentCategory == "Закрепленные" {
//            unpinTracker(at: indexPath)
//        } else {
//            pinTracker(tracker, from: currentCategory)
//        }
//
//        fetchCategoryAndUpdateUI()
//    }
//
    func pinTracker(id: UUID, at indexPath: IndexPath) {
        do {
          try self.trackerStore.pinTracker(id: id, at: indexPath)
            guard let tracker = tracker else { return }
           try self.trackerStore.changeTrackerPinStatus(tracker)
            collectionView.reloadData()
        } catch {
            print("Failed to pin tracker: \(error)")
        }
        collectionView.reloadData()
        fetchCategoryAndUpdateUI()
        print(#function)
    }
    
    func unpinTracker(at indexPath: IndexPath) {
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        try? trackerCategoryStore.deleteTrackerFromCategory(tracker: tracker, from: "Закрепленные")
        if let originalCategory = originalCategories[tracker.id] {
            try? trackerCategoryStore.addNewTrackerToCategory(tracker, to: originalCategory)
            originalCategories.removeValue(forKey: tracker.id)
        }
      
        fetchCategoryAndUpdateUI()
    }
    
        func editTracker(at indexPath: IndexPath) {
            let vc = TrackerCreationScreenViewController()
            //vc.delegate = self
            let tracker = self.visibleCategories[indexPath.section].trackers[indexPath.row]
            //vc.categoryName = self.visibleCategories[indexPath.section].title
           // vc.setTrackerData(tracker: tracker)
            vc.editTracker = tracker
            vc.category = tracker.category
            self.present(vc, animated: true)
        }
//    func editTracker(id: UUID, at indexPath: IndexPath) {
//        print(#function)
//        do {
//            let tracker = try trackerStore.fetchTrackerByID(id: id, at: indexPath)
//            // let category = categories[indexPath.section]
//            let editTrackerViewController = TrackerCreationScreenViewController()
//            editTrackerViewController.editTracker = tracker
//            editTrackerViewController.category = tracker.category
//            self.present(editTrackerViewController, animated: true)
//        } catch {
//            print("Failed to pin editTracker")
//        }
    //}
    func deleteTracker(id: UUID, at indexPath: IndexPath) {
        let actionSheet: UIAlertController = {
                    let alert = UIAlertController()
                    alert.title = "Уверены, что хотите удалить трекер?"
                    return alert
                }()
        
                let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
                    //                    self?.deleteTracker(<#T##tracker: Tracker##Tracker#>)
                    do {
                        try self?.trackerStore.deleteTracker(id: id, at: indexPath)
                        self?.trackerRecordStore.update()
                        //self?.reloadData()
                        self?.collectionView.reloadData()
                    } catch {
                        print("Failed to delete tracker: \(error)")
                    }
                    print(#function)
        
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
                actionSheet.addAction(deleteAction)
                actionSheet.addAction(cancelAction)
        
                present(actionSheet, animated: true)
    }
    
//    func deleteTracker(id: UUID, at indexPath: IndexPath) {
//        let actionSheet: UIAlertController = {
//            let alert = UIAlertController()
//            alert.title = NSLocalizedString("deleteTrackerAlert.title", comment: "")
//            return alert
//        }()
//
//        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
//            //                    self?.deleteTracker(<#T##tracker: Tracker##Tracker#>)
//            do {
 //               try self?.trackerStore.deleteTracker(id: id, at: indexPath)
//                //self?.reloadData()
//                self?.collectionView.reloadData()
//            } catch {
//                print("Failed to delete tracker: \(error)")
//            }
//            print(#function)
//
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//
//        actionSheet.addAction(deleteAction)
//        actionSheet.addAction(cancelAction)
//
//        present(actionSheet, animated: true)
//    }
    
    
//    func record(_ sender: Bool, _ cell: TrackersCollectionViewCell) {
//        guard let indexPath = collectionView.indexPath(for: cell) else { return }
//        let id = visibleCategories[indexPath.section].trackers[indexPath.row].id
//        let newRecord = TrackerRecord(id: id, date: todaysDate)
//
//        switch sender {
//        case true:
//            completedTrackers.insert(newRecord)
//        case false:
//            completedTrackers.remove(newRecord)
//        }
//
//        collectionView.reloadItems(at: [indexPath])
//    }
    
//    func isTrackerPinned(at indexPath: IndexPath) -> Bool {
//        return visibleCategories[indexPath.section].title == "Закрепленные"
//    }
    
    //
   
    //
    //    func editTracker(id: UUID, at indexPath: IndexPath) {
    //        print(#function)
    //        do {
    //            let tracker = try trackerStore.fetchTrackerByID(id: id, at: indexPath)
    //           // let category = categories[indexPath.section]
    //            let editTrackerViewController = TrackerCreationScreenViewController()
    //              editTrackerViewController.editTracker = tracker
    //            editTrackerViewController.category = tracker.category
    //            self.present(editTrackerViewController, animated: true)
    //        } catch {
    //            print("Failed to pin editTracker")
    //        }
    //    }
    //
    //    func deleteTracker(id: UUID, at indexPath: IndexPath) {
    //        print("Failed to pin deleteTracker")
    //
    //        let actionSheet: UIAlertController = {
    //                    let alert = UIAlertController()
    //                    alert.title = NSLocalizedString("deleteTrackerAlert.title", comment: "")
    //                    return alert
    //                }()
    //
    //                let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
    ////                    self?.deleteTracker(<#T##tracker: Tracker##Tracker#>)
    //                    do {
    //                        try self?.trackerStore.deleteTracker(id: id, at: indexPath)
    //                        //self?.reloadData()
    //                        self?.collectionView.reloadData()
    //                    } catch {
    //                        print("Failed to delete tracker: \(error)")
    //                    }
    //                    print(#function)
    //
    //                }
    //                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    //
    //                actionSheet.addAction(deleteAction)
    //                actionSheet.addAction(cancelAction)
    //
    //                present(actionSheet, animated: true)
    //    }
    //
    //   func completeTracker(id: UUID, at indexPath: IndexPath) {
    //        if datePicker.date <= Date() {
    //            let record = TrackerRecord(id: id, date: datePicker.date)
    //            completedTrackers.append(record)
    //            try? trackerRecordStore.addNewTracker(record)
    //            collectionView.reloadItems(at: [indexPath])
    //        }
    //        trackerRecordStore.update()
    //    }
    //
    //    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
    //        completedTrackers.removeAll { trackerRecord in
    //            isSameTracker(trackerRecord: trackerRecord, id: id)
    //        }
    //        //if let record = trackerRecordStore.fetchRecord(by: id, and: datePicker.date) {
    //        try? trackerRecordStore.deleteTrackerRecord(with: id, date: getSelectedDate())
    //        collectionView.reloadItems(at: [indexPath])
    //        }
    //
    //    func getSelectedDate() -> Date {
    //        let calendar = Calendar.current
    //        let dateComponents = calendar.dateComponents([.year, .month, .day], from: datePicker.date)
    //        guard let selectedDate = calendar.date(from: dateComponents) else { return Date() }
    //        return selectedDate
    //    }
    //
}


// MARK: - UITextFieldDelegate

extension TackersVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = searchTextField.text ?? ""
      //  reloadVisibleCategories(with: trackerCategoryStore.predicateFetch(trackerTitle: searchText))
        collectionView.reloadData()
        return true
    }
}

extension TackersVC: TrackerCategoryStoreDelegate {
    func store(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate) {
        visibleCategories = trackerCategoryStore.trackerCategories
        collectionView.reloadData()
    }
}

extension TackersVC: FiltersViewControllerDelegate {
    func filterSelected(filter: Filters) {
        selectedFilter = filter
        useFilter()
    }
}

// MARK: - TrackerStoreDelegate
extension TackersVC: TrackerStoreDelegate {
    func store(_ store: TrackerStore, didUpdate update: TrackerStoreUpdate) {
        //reloadVisibleCategories(with: trackerCategoryStore.trackerCategories)
        collectionView.reloadData()
    }
}

// MARK: - TrackerRecordStoreDelegate
extension TackersVC: TrackerRecordStoreDelegate {
    func store(_ store: TrackerRecordStore, didUpdate update: TrackerRecordStoreUpdate) {
      //  completedTrackers = trackerRecordStore.trackerRecords
        collectionView.reloadData()
    }
}

extension TackersVC: StatisticViewControllerDelegate {
    func updateStatistics() {
        return
    }
}
// MARK: - TrackerCreationScreenViewControllerDelegate

extension TackersVC: TrackerCreationScreenViewControllerDelegate {
    func createButtonidTap(tracker: Tracker, category: String) {
        var updatedCategory: TrackerCategory?
        let categories: [TrackerCategory] = trackerCategoryStore.trackerCategories
        
        for item in 0..<categories.count {
            if categories[item].title == category {
                updatedCategory = categories[item]
            }
        }
        
        if updatedCategory != nil {
            try? trackerCategoryStore.addTrackerToCategory(tracker, to: updatedCategory ?? TrackerCategory(
                title: category,
                trackers: [tracker]
            ))
        } else {
            let trackerCategory = TrackerCategory(
                title: category,
                trackers: [tracker]
            )
            updatedCategory = trackerCategory
            try? trackerCategoryStore.addNewTrackerCategory(updatedCategory ?? TrackerCategory(
                title: category,
                trackers: [tracker]
            ))
        }
        collectionView.reloadData()
      //  reloadVisibleCategories(with: trackerCategoryStore.trackerCategories)
    }
}

extension TackersVC {
    
    private func isTrackerScheduledForToday(tracker: Tracker) -> Bool {
        // Логика для проверки, запланирован ли трекер на сегодня
        let calendar = Calendar.current
        let today = calendar.component(.weekday, from: todaysDate) - 1
        let day = WeekDay.allCases[today].rawValue
        return tracker.schedule.contains(WeekDay(rawValue: day) ?? .monday)
    }
    
    private func isTrackerCompletedOnDate(tracker: Tracker, date: Date) -> Bool {
        return completedTrackers.contains { record in
            record.id == tracker.id && Calendar.current.isDate(record.date, inSameDayAs: date)
        }
    }
    
    //    private func showPlaceholder() {
    //        placeholderImageView.isHidden = false
    //        placeholderLabel.isHidden = false
    //        collectionView.isHidden = true
    //    }
    //
    //    private func hidePlaceholder() {
    //        placeholderImageView.isHidden = true
    //        placeholderLabel.isHidden = true
    //        collectionView.isHidden = false
    //    }
    
    private func filteredTrackers() {
        let calendar = Calendar.current
        let selectedWeekDay = calendar.component(.weekday, from: todaysDate) - 1
        let day = WeekDay.allCases[selectedWeekDay].rawValue
        let selectedDayString = WeekDay(rawValue: day)
        
        visibleCategories = categories.compactMap { category in
            let filteredTrackers = category.trackers.filter { tracker in
                return tracker.schedule.contains(selectedDayString ?? .monday)
            }
            return !filteredTrackers.isEmpty ? TrackerCategory(title: category.title, trackers: filteredTrackers) : nil
        }
        collectionView.reloadData()
        
    }
    
    private func useFilter() {
        switch selectedFilter {
            
        case .allTrackers:
            filteredTrackers()
            
        case .completedTrackers:
            visibleCategories = categories.map { category in
                let completedTrackers = category.trackers.filter { tracker in
                    return isTrackerCompletedOnDate(tracker: tracker, date: todaysDate)
                }
                return TrackerCategory(title: category.title, trackers: completedTrackers)
            }.filter { !$0.trackers.isEmpty }
            collectionView.reloadData()
            
            
        case .uncompletedTrackers:
            visibleCategories = categories.map { category in
                let notCompletedTrackers = category.trackers.filter { tracker in
                    return !isTrackerCompletedOnDate(tracker: tracker, date: todaysDate) && isTrackerScheduledForToday(tracker: tracker)
                }
                return TrackerCategory(title: category.title, trackers: notCompletedTrackers)
            }.filter { !$0.trackers.isEmpty }
            collectionView.reloadData()
            
            
            //        if visibleCategories.isEmpty {
            //            showPlaceholder()
            //        } else {
            //            hidePlaceholder()
            //        }
            
            
        case .trackersForToday:
            visibleCategories = categories.map { category in
                let trackersForToday = category.trackers.filter { tracker in
                    return isTrackerScheduledForToday(tracker: tracker)
                }
                return TrackerCategory(title: category.title, trackers: trackersForToday)
            }.filter { !$0.trackers.isEmpty }
            collectionView.reloadData()
        }
        
       //!!!!!!!!!!!!!!!!!!!!!!!!!!!! showNothingWasFoundView()
    }
    
    private func syncData() {
        trackerCategoryStore.delegate = self
        trackerRecordStore.delegate = self
        trackerStore.delegate = self
        fetchCategory()
        fetchRecord()
        if !categories.isEmpty {
            visibleCategories = categories
            collectionView.reloadData()
        }
      //  showNothingWasFoundView()
    }
    
    private func fetchCategory() {
        do {
            let coreDataCategories = try trackerCategoryStore.fetchCategories()
            categories = coreDataCategories.compactMap { coreDataCategory in
                trackerCategoryStore.updateTrackerCategory(coreDataCategory)
            }
            
            var trackers = [Tracker]()
            
            for visibleCategory in visibleCategories {
                for tracker in visibleCategory.trackers {
                    let newTracker = Tracker(
                        id: tracker.id,
                        title: tracker.title,
                        color: tracker.color,
                        emoji: tracker.emoji,
                        schedule: tracker.schedule,
                        isPinned: tracker.isPinned)
                    trackers.append(newTracker)
                }
            }
            self.trackers = trackers
        } catch {
            print("Error fetching categories: \(error)")
        }
    }
    
    private func fetchRecord()  {
        do {
            completedTrackers = try trackerRecordStore.fetchRecords()
        } catch {
            print("Ошибка при добавлении записи: \(error)")
        }
    }
    
    private func createRecord(record: TrackerRecord)  {
        do {
            try trackerRecordStore.addNewTracker(record)
            fetchRecord()
        } catch {
            print("Ошибка при добавлении записи: \(error)")
        }
    }
    
    private func deleteRecord(record: TrackerRecord)  {
        do {
            try trackerRecordStore.deleteTrackerRecord(trackerRecord: record)
            fetchRecord()
        } catch {
            print("Ошибка при удалении записи: \(error)")
        }
    }
    
    private func ensurePinnedCategoryExists() {
        let pinnedCategoryTitle = "Закрепленные"
        do {
            if try !trackerCategoryStore.fetchCategories().contains(where: { $0.title == pinnedCategoryTitle }) {
                let newCategory = TrackerCategory(title: pinnedCategoryTitle, trackers: [])
                try trackerCategoryStore.addNewCategory(newCategory)
            }
        } catch {
            print("Failed to ensure pinned category exists: \(error)")
        }
    }
    private func pinTracker(_ tracker: Tracker, from category: String) {
        ensurePinnedCategoryExists()
        try? trackerCategoryStore.deleteTrackerFromCategory(tracker: tracker, from: category)
        originalCategories[tracker.id] = category
        try? trackerCategoryStore.addNewTrackerToCategory(tracker, to: "Закрепленные")
        
        fetchCategoryAndUpdateUI()
    }
    
    private func fetchCategoryAndUpdateUI() {
        fetchCategory()
        visibleCategories = categories
        collectionView.reloadData()
    }
    
    func deleteTracker(_ tracker: Tracker) {
        try? self.trackerStore.deleteTracker(tracker)
        trackerRecordStore.update()
        updateStatistics()
        do {
            try trackerStore.deleteTracker(tracker)
        } catch {
            print("Ошибка при удалении трекера: \(error)")
        }

        do {
            try trackerRecordStore.deleteAllTrackerRecords(with: tracker.id)
        } catch {
            print("Ошибка при удалении записей: \(error)")
        }
       
    }
}

