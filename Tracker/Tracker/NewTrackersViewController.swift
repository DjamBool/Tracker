////
////  NewTrackersViewController.swift
////  Tracker
////
////  Created by Игорь Мунгалов on 19.06.2024.
////
//
//import UIKit
//
//final class NewTrackersViewController: UIViewController {
//    
//    var tracker: Tracker? = nil
//    private let colors = Colors()
//    private var searchText: String = ""
//    private let filterButtonTitle = NSLocalizedString("filterButtonTitleText", comment: "")
//    
//    private let trackerCategoryStore = TrackerCategoryStore()
//    private let trackerStore = TrackerStore()
//    private let trackerRecordStore = TrackerRecordStore()
//    //private let analyticsService = AnalyticsService()
//    
//    private var trackers = [Tracker]()
//    private var categories: [TrackerCategory] = []
//    private var visibleCategories: [TrackerCategory] = []
//    private var originalCategories: [UUID: String] = [:]
//    private var completedTrackers: Set<TrackerRecord> = []
//    private var currentDate: Date = Date()
//    private var selectedWeekDay: WeekDay = .monday
//    private var currentFilter: Filters = .allTrackers
//    
//    private lazy var dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        formatter.timeStyle = .none
//        return formatter
//    }()
//    
//    private var navBarTitleLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = NSLocalizedString("navBarTitleLabelText", comment: "")
//        label.textColor = .ypBlack
//        label.font = UIFont.boldSystemFont(ofSize: 34)
//        return label
//    }()
//    
//    private lazy var datePicker: UIDatePicker = {
//        let datePicker = UIDatePicker()
//        datePicker.translatesAutoresizingMaskIntoConstraints = false
//        datePicker.clipsToBounds = true
//        datePicker.layer.cornerRadius = 10
//        datePicker.setValue(UIColor.ypWhite, forKey: "textColor")
//        datePicker.datePickerMode = .date
//        datePicker.preferredDatePickerStyle = .compact
//        datePicker.locale = Locale(identifier: "ru_Ru")
//        datePicker.tintColor = .colorSelection3
//        NSLayoutConstraint.activate([
//            datePicker.widthAnchor.constraint(equalToConstant: 100)])
//        datePicker.addTarget(self,
//                             action: #selector(datePickerValueChanged),
//                             for: .valueChanged)
//        return datePicker
//    }()
//    
//    private lazy var searchTextField: UISearchTextField = {
//        let textField = UISearchTextField()
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.placeholder = "Поиск"
//        textField.backgroundColor = colors.viewColor
//        textField.font = UIFont.systemFont(ofSize: 17)
//        textField.delegate = self
//        return textField
//    }()
//    
//    private var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: TrackersCollectionViewCell.identifier)
//        
//        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
//        
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        return collectionView
//    }()
//    
//    private lazy var whatWillWeTrackView: WhatWillWeTrackView = {
//        let view = WhatWillWeTrackView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    private lazy var nothingWasFoundView: NothingWasFoundView = {
//        let view = NothingWasFoundView()
//        view.isHidden = true
//        
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    private lazy var filterButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.backgroundColor = UIColor.ypBlue
//        button.setTitle(filterButtonTitle, for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 17,
//                                                    weight: .regular)
//        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
//        button.layer.cornerRadius = 16
//        
//        return button
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setupNavigationBar()
//        setupUI()
//        syncData()
//        updateUI()
//        
//        searchTextField.delegate = self
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        //analyticsService.report(event: "open", params: ["screen": "Main"])
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(true)
//       // analyticsService.report(event: "close", params: ["screen": "Main"])
//    }
//    
//    @objc private func addTrackerButtonTapped() {
//       // analyticsService.report(event: "click", params: ["screen": "Main", "item": "add_track"])
//        let trackerСreatingViewController = TrackerCreatingViewController()
//        trackerСreatingViewController.delegate = self
//        present(trackerСreatingViewController, animated: true)
//    
//    }
//    
//    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
//        currentDate = sender.date
//        filteredTrackers()
//        applyFilter()
//        updateUI()
//    }
//    
//    @objc private func filterButtonTapped(_ sender: UIButton) {
//      //  analyticsService.report(event: "click", params: ["screen": "Main", "item": "filter"])
//        let filterViewController = FiltersViewController()
//        filterViewController.delegate = self
//        let filterNavController = UINavigationController(rootViewController: filterViewController)
//        self.present(filterNavController, animated: true)
//    }
//    
//    private func syncData() {
//        trackerCategoryStore.delegate = self
//        trackerStore.delegate = self
//        fetchCategory()
//        fetchRecord()
//        if !categories.isEmpty {
//            visibleCategories = categories
//            collectionView.reloadData()
//        }
//        
//        updateUI()
//    }
//
//    private func filteredTrackers() {
//        let calendar = Calendar.current
//        let selectedWeekDay = calendar.component(.weekday, from: currentDate) - 1
//        let selectedDayString = WeekDay(rawValue: selectedWeekDay)?.stringValue ?? ""
//        
//        visibleCategories = categories.compactMap { category in
//            let filteredTrackers = category.trackers.filter { tracker in
//                return tracker.schedule.contains(selectedDayString)
//            }
//            return !filteredTrackers.isEmpty ? TrackerCategory(title: category.title, trackers: filteredTrackers) : nil
//        }
//
//        collectionView.reloadData()
//    }
//    
//    func addTracker(_ tracker: Tracker, to category: TrackerCategory) {
//        do {
//            if let categoryIndex = categories.firstIndex(where: { $0.title == category.title }) {
//                categories[categoryIndex].trackers.append(tracker)
//            } else {
//                let newCategory = TrackerCategory(
//                    title: category.title,
//                    trackers: [tracker])
//                categories.append(newCategory)
//            }
//            visibleCategories = categories
//            
//            if try trackerCategoryStore.fetchCategories().filter({$0.title == category.title}).count == 0 {
//                let newCategoryCoreData = TrackerCategory(title: category.title, trackers: [])
//                try trackerCategoryStore.addNewCategory(newCategoryCoreData)
//            }
//            
//            createCategoryAndTracker(tracker: tracker, with: category.title)
//            fetchCategory()
//            collectionView.reloadData()
//            updateUI()
//        } catch {
//            print("Error: \(error)")
//        }
//    }
//    
//    private func setupUI() {
//        view.backgroundColor = .white
//        
//        [collectionView,
//         placeholderImageView,
//         placeholderLabel, filterButton].forEach{
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            view.addSubview($0)
//        }
//        
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
//        ])
//        
//        NSLayoutConstraint.activate([
//            placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            placeholderImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            placeholderImageView.widthAnchor.constraint(equalToConstant: 80),
//            placeholderImageView.heightAnchor.constraint(equalToConstant: 80),
//            
//            placeholderLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 10),
//            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            
//            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
//            filterButton.widthAnchor.constraint(equalToConstant: 115),
//            filterButton.heightAnchor.constraint(equalToConstant: 50)
//        ])
//    }
//    
//    private func setupNavigationBar() {
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.title = NSLocalizedString("Trackers", comment: "Title for the main screen")
//        
//        let addButton = UIBarButtonItem(
//            barButtonSystemItem: .add,
//            target: self,
//            action: #selector(addTrackerButtonTapped))
//        navigationItem.leftBarButtonItem = addButton
//        navigationItem.leftBarButtonItem?.tintColor = .black
//        
//        datePicker.addTarget(
//            self,
//            action: #selector(datePickerValueChanged),
//            for: .valueChanged
//        )
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
//        
//        navigationItem.searchController = searchBar
//    }
//    
//    private func updateUI() {
//        if visibleCategories.isEmpty {
//            placeholderImageView.isHidden = false
//            placeholderLabel.isHidden = false
//            filterButton.isHidden = true
//            collectionView.isHidden = true
//        } else {
//            placeholderImageView.isHidden = true
//            placeholderLabel.isHidden = true
//            collectionView.isHidden = false
//            filterButton.isHidden = false
//            collectionView.reloadData()
//        }
//    }
//}
//
//extension NewTrackersViewController: UICollectionViewDataSource {
//    func collectionView(
//        _ collectionView: UICollectionView,
//        numberOfItemsInSection section: Int
//    ) -> Int {
//        return visibleCategories[section].trackers.count
//    }
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return visibleCategories.count
//    }
//    
//    func collectionView(
//        _ collectionView: UICollectionView,
//        cellForItemAt indexPath: IndexPath
//    ) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier,
//            for: indexPath
//        ) as? TrackerCollectionViewCell else {
//            assertionFailure("Unable to dequeue TrackerCollectionViewCell")
//            return UICollectionViewCell()
//        }
//
//        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
//        let id = visibleCategories[indexPath.section].trackers[indexPath.row].id
//        
//        cell.delegate = self
//        let isCompletedToday = isTrackerCompletedToday(id: tracker.id)
//        let completedDays = completedTrackers.filter {
//            $0.trackerID == tracker.id
//        }.count
//        
//        cell.configure(
//            with: tracker,
//            trackerIsCompleted: isCompletedToday,
//            completedDays: completedDays,
//            indexPath: indexPath
//        )
//        
//        return cell
//    }
//    
//    private func isTrackerCompletedToday(id: UUID) -> Bool {
//        completedTrackers.contains { trackerRecord in
//            isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
//        }
//    }
//    
//    private func isSameTrackerRecord(trackerRecord: TrackerRecord, id: UUID) -> Bool {
//        let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
//        return trackerRecord.trackerID == id && isSameDay
//    }
//    
//    func collectionView(
//        _ collectionView: UICollectionView,
//        viewForSupplementaryElementOfKind kind: String,
//        at indexPath: IndexPath
//    ) -> UICollectionReusableView {
//        var id: String
//        switch kind {
//        case UICollectionView.elementKindSectionHeader:
//            id = SupplementaryView.reuseIdentifier
//        default:
//            id = ""
//        }
//        
//        let view = collectionView.dequeueReusableSupplementaryView(
//            ofKind: kind,
//            withReuseIdentifier: id,
//            for: indexPath
//        ) as! SupplementaryView
//        
//        let title = visibleCategories[indexPath.section].title
//        view.setTitle(title)
//        return view
//    }
//}
//
//extension NewTrackersViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(
//        _ collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        referenceSizeForHeaderInSection section: Int
//    ) -> CGSize {
//        let indexPath = IndexPath(row: 0, section: section)
//        let headerView = self.collectionView(
//            collectionView,
//            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
//            at: indexPath
//        )
//        
//        var height = CGFloat()
//        if section == 0 {
//            height = 42
//        } else {
//            height = 34
//        }
//        
//        return headerView.systemLayoutSizeFitting(
//            CGSize(
//            width: collectionView.frame.width,
//            height: height),
//            withHorizontalFittingPriority: .required,
//            verticalFittingPriority: .fittingSizeLevel
//        )
//    }
//    
//    func collectionView(
//        _ collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        sizeForItemAt indexPath: IndexPath
//    ) -> CGSize {
//        return CGSize(
//            width: (collectionView.bounds.width - 9) / 2,
//            height: 148
//        )
//    }
//    
//    func collectionView(
//        _ collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        minimumInteritemSpacingForSectionAt section: Int
//    ) -> CGFloat {
//        return 9
//    }
//}
//
//extension NewTrackersViewController: TrackerCollectionViewCellDelegate {
//    func completeTracker(id: UUID, at indexPath: IndexPath) {
//        //analyticsService.report(event: "click", params: ["screen": "Main", "item": "track"])
//        if currentDate <= Date() {
//            let trackerRecord = TrackerRecord(trackerID: id, date: datePicker.date)
//            completedTrackers.insert(trackerRecord)
//            createRecord(record: trackerRecord)
//            collectionView.reloadItems(at: [indexPath])
//        }
//    }
//    
//    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
//        if let trackerRecordToDelete = completedTrackers.first(where: { $0.trackerID == id }) {
//            completedTrackers.remove(trackerRecordToDelete)
//            deleteRecord(record: trackerRecordToDelete)
//            
//            collectionView.reloadItems(at: [indexPath])
//        }
//    }
//   
//    func record(_ sender: Bool, _ cell: TrackerCollectionViewCell) {
//        guard let indexPath = collectionView.indexPath(for: cell) else { return }
//        let id = visibleCategories[indexPath.section].trackers[indexPath.row].id
//        let newRecord = TrackerRecord(trackerID: id, date: currentDate)
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
//    
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
//    func unpinTracker(at indexPath: IndexPath) {
//        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
//        try? trackerCategoryStore.deleteTrackerFromCategory(tracker: tracker, from: "Закрепленные")
//        if let originalCategory = originalCategories[tracker.id] {
//            try? trackerCategoryStore.addNewTrackerToCategory(tracker, to: originalCategory)
//            originalCategories.removeValue(forKey: tracker.id)
//        }
//        
//        fetchCategoryAndUpdateUI()
//    }
//    
//    func isTrackerPinned(at indexPath: IndexPath) -> Bool {
//        return visibleCategories[indexPath.section].title == "Закрепленные"
//    }
//    
//    private func pinTracker(_ tracker: Tracker, from category: String) {
//        ensurePinnedCategoryExists()
//        try? trackerCategoryStore.deleteTrackerFromCategory(tracker: tracker, from: category)
//        originalCategories[tracker.id] = category
//        try? trackerCategoryStore.addNewTrackerToCategory(tracker, to: "Закрепленные")
//        
//        fetchCategoryAndUpdateUI()
//    }
//    
//    private func fetchCategoryAndUpdateUI() {
//        fetchCategory()
//        visibleCategories = categories
//        collectionView.reloadData()
//    }
//    
//    private func ensurePinnedCategoryExists() {
//        let pinnedCategoryTitle = "Закрепленные"
//        do {
//            if try !trackerCategoryStore.fetchCategories().contains(where: { $0.title == pinnedCategoryTitle }) {
//                let newCategory = TrackerCategory(title: pinnedCategoryTitle, trackers: [])
//                try trackerCategoryStore.addNewCategory(newCategory)
//            }
//        } catch {
//            print("Failed to ensure pinned category exists: \(error)")
//        }
//    }
//    
//    func editTracker(at indexPath: IndexPath) {
//       // analyticsService.report(event: "click", params: ["screen": "Main", "item": "edit"])
//        let vc = NewHabitViewController()
//        vc.delegate = self
//        let tracker = self.visibleCategories[indexPath.section].trackers[indexPath.row]
//        vc.categoryName = self.visibleCategories[indexPath.section].title
//        vc.setTrackerData(tracker: tracker)
//        present(vc, animated: true)
//    }
//    
//    func deleteTracker(at indexPath: IndexPath) {
//       // analyticsService.report(event: "click", params: ["screen": "Main", "item": "delete"])
//        let alert = UIAlertController(title: "", message: "Уверены, что хотите удалить трекер?", preferredStyle: .alert)
//        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [self] _ in
//            let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
//            trackerStore.deleteTracker(tracker: tracker)
//
//            fetchCategoryAndUpdateUI()
//        }
//        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel) { _ in }
//        alert.addAction(deleteAction)
//        alert.addAction(cancelAction)
//        self.present(alert, animated: true, completion: nil)
//    }
//}
//
//extension NewTrackersViewController: NewTrackerViewControllerDelegate {
//    func setDateForNewTracker() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd.MM.yyyy"
//        return dateFormatter.string(from: currentDate)
//    }
//    
//    func didCreateNewTracker(_ tracker: Tracker, _ category: TrackerCategory) {
//        addTracker(tracker, to: category)
//    }
//    
//    func didEditTracker(_ tracker: Tracker) {
//        for (categoryIndex, category) in visibleCategories.enumerated() {
//            if let trackerIndex = category.trackers.firstIndex(where: { $0.id == tracker.id }) {
//                visibleCategories[categoryIndex].trackers[trackerIndex] = tracker
//            }
//        }
//        
//        if let updatedTrackerEntity = trackerStore.updateTracker(tracker) {
//            if let category = trackerCategoryStore.category(with: tracker.schedule) {
//                trackerCategoryStore.updateTrackerCategory(category)
//            }
//        }
//        collectionView.reloadData()
//        
//    }
//}
//
//extension NewTrackersViewController: TrackerCategoryStoreDelegate {
//    func didUpdateCategories() {
//        collectionView.reloadData()
//    }
//}
//
//extension NewTrackersViewController {
//    private func fetchCategory() {
//        do {
//            let coreDataCategories = try trackerCategoryStore.fetchCategories()
//            categories = coreDataCategories.compactMap { coreDataCategory in
//                trackerCategoryStore.updateTrackerCategory(coreDataCategory)
//            }
//
//            var trackers = [Tracker]()
//            
//            for visibleCategory in visibleCategories {
//                for tracker in visibleCategory.trackers {
//                    let newTracker = Tracker(
//                        id: tracker.id,
//                        name: tracker.name,
//                        color: tracker.color,
//                        emoji: tracker.emoji,
//                        schedule: tracker.schedule)
//                    trackers.append(newTracker)
//                }
//            }
//            
//            self.trackers = trackers
//        } catch {
//            print("Error fetching categories: \(error)")
//        }
//    }
//    
//    private func createCategoryAndTracker(tracker: Tracker, with titleCategory: String) {
//        trackerCategoryStore.createCategoryAndTracker(tracker: tracker, with: titleCategory)
//    }
//}
//
//extension NewTrackersViewController {
//    private func fetchRecord()  {
//        do {
//            completedTrackers = try trackerRecordStore.fetchRecords()
//        } catch {
//            print("Ошибка при добавлении записи: \(error)")
//        }
//    }
//    
//    private func createRecord(record: TrackerRecord)  {
//        do {
//            try trackerRecordStore.addNewRecord(from: record)
//            fetchRecord()
//        } catch {
//            print("Ошибка при добавлении записи: \(error)")
//        }
//    }
//    
//    private func deleteRecord(record: TrackerRecord)  {
//        do {
//            try trackerRecordStore.deleteTrackerRecord(trackerRecord: record)
//            fetchRecord()
//        } catch {
//            print("Ошибка при удалении записи: \(error)")
//        }
//    }
//}
//
//extension NewTrackersViewController {
//    private func applyFilter() {
//        switch currentFilter {
//        case .allTrackers:
//            // Отображаются все трекеры на выбранный в календаре день и при переключении дней.
//            filteredTrackers()
//        case .trackersForToday:
//            // Логика для фильтра "Трекеры на сегодня"
//            visibleCategories = categories.map { category in
//                let trackersForToday = category.trackers.filter { tracker in
//                    return isTrackerScheduledForToday(tracker: tracker)
//                }
//                return TrackerCategory(title: category.title, trackers: trackersForToday)
//            }.filter { !$0.trackers.isEmpty }
//            collectionView.reloadData()
//        case .completedTrackers:
//            // Логика для фильтрации завершенных трекеров
//            visibleCategories = categories.map { category in
//                let completedTrackers = category.trackers.filter { tracker in
//                    return isTrackerCompletedOnDate(tracker: tracker, date: currentDate)
//                }
//                return TrackerCategory(title: category.title, trackers: completedTrackers)
//            }.filter { !$0.trackers.isEmpty }
//            collectionView.reloadData()
//        case .uncompletedTrackers:
//            // Логика для фильтрации незавершенных трекеров
//            visibleCategories = categories.map { category in
//                let notCompletedTrackers = category.trackers.filter { tracker in
//                    return !isTrackerCompletedOnDate(tracker: tracker, date: currentDate) && isTrackerScheduledForToday(tracker: tracker)
//                }
//                return TrackerCategory(title: category.title, trackers: notCompletedTrackers)
//            }.filter { !$0.trackers.isEmpty }
//            collectionView.reloadData()
//        }
//        
//        if visibleCategories.isEmpty {
//            showPlaceholder()
//        } else {
//            hidePlaceholder()
//        }
//    }
//    
//    private func isTrackerScheduledForToday(tracker: Tracker) -> Bool {
//        // Логика для проверки, запланирован ли трекер на сегодня
//        let calendar = Calendar.current
//        let today = calendar.component(.weekday, from: currentDate) - 1
//        let todayString = WeekDay(rawValue: today)?.stringValue ?? ""
//        return tracker.schedule.contains(todayString)
//    }
//    
//    private func isTrackerCompletedOnDate(tracker: Tracker, date: Date) -> Bool {
//        return completedTrackers.contains { record in
//            record.trackerID == tracker.id && Calendar.current.isDate(record.date, inSameDayAs: date)
//        }
//    }
//    
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
//}
//
//extension NewTrackersViewController: FiltersViewControllerDelegate {
//    func didSelectFilter(_ filter: Filters) {
//        currentFilter = filter
//        applyFilter()
//    }
//}
//
//extension NewTrackersViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        searchText = searchTextField.text ?? ""
//       // reloadVisibleCategories(with: trackerCategoryStore.predicateFetch(trackerTitle: searchText))
//        collectionView.reloadData()
//        return true
//    }
//}
//
//extension NewTrackersViewController: TrackersDelegate {
//    func addedNew(tracker: Tracker, categoryTitle: String) {
//        var updatedCategory: TrackerCategory?
//        let categories: [TrackerCategory] = trackerCategoryStore.trackerCategories
//        
//        for item in 0..<categories.count {
//            if categories[item].title == categoryTitle {
//                updatedCategory = categories[item]
//            }
//        }
//        
//        if updatedCategory != nil {
//            try? trackerCategoryStore.addTrackerToCategory(tracker, to: updatedCategory ?? TrackerCategory(
//                title: categoryTitle,
//                trackers: [tracker]
//            ))
//        } else {
//            let trackerCategory = TrackerCategory(
//                title: categoryTitle,
//                trackers: [tracker]
//            )
//            updatedCategory = trackerCategory
//            try? trackerCategoryStore.addNewTrackerCategory(updatedCategory ?? TrackerCategory(
//                title: categoryTitle,
//                trackers: [tracker]
//            ))
//        }
//        dismiss(animated: true)
//      //  reloadVisibleCategories(with: trackerCategoryStore.trackerCategories)
//    }
//}



func chingiz() {
   /*
    extension TrackersViewController {
        
        private func filterTrackers(_ categories: [TrackerCategory], completed: Bool) -> [TrackerCategory] {
            var filteredCategories: [TrackerCategory] = []
            for category in categories {
                let filteredTrackers = category.trackers.filter { tracker in
                    let trackerRecords = getRecords(for: tracker)
                    let isCompleted = trackerRecords.contains { record in
                        return Calendar.current.isDate(record.date, inSameDayAs: datePicker.date)
                    }
                    return isCompleted == completed
                }
                if !filteredTrackers.isEmpty {
                    filteredCategories.append(TrackerCategory(title: category.title, trackers: filteredTrackers))
                }
            }
            return filteredCategories
        }
        
        private func getRecords(for tracker: Tracker) -> [TrackerRecord] {
            
            return trackerRecordStore.trackerRecords
        }
        
        private func filterCompletedTrackers(_ categories: [TrackerCategory]) -> [TrackerCategory] {
            return filterTrackers(categories, completed: true)
        }
        
        private func filterNotCompletedTrackers(_ categories: [TrackerCategory]) -> [TrackerCategory] {
            return filterTrackers(categories, completed: false)
        }
        
        //    private func updateFilter() {
        //        if let currentFilter = selectedFilter {
        //            switch currentFilter {
        //            case NSLocalizedString("All trackers", comment: ""):
        //                visibleCategories = filterTrackersBySelectedDate()
        //            case NSLocalizedString("Trackers for today", comment: ""):
        //                datePicker.date = Date()
        //                currentDate = datePicker.date
        //                visibleCategories = filterTrackersBySelectedDate()
        //            case NSLocalizedString("Completed", comment: ""):
        //                visibleCategories = filterCompletedTrackers(filterTrackersBySelectedDate())
        //            case NSLocalizedString("Not completed", comment: ""):
        //                visibleCategories = filterNotCompletedTrackers(filterTrackersBySelectedDate())
        //            default:
        //                break
        //            }
        //        } else {
        //            visibleCategories = filterTrackersBySelectedDate()
        //        }
        //    }
        
        private func filterTrackersBySelectedDate() -> [TrackerCategory] {
            var categoriesFromCoreData = [TrackerCategory]()
            
    //        let selectedWeekday = Calendar.current.component(.weekday, from: datePicker.date)
    //
            var filteredCategories: [TrackerCategory] = []
            var pinnedTrackers: [Tracker] = []
            
            for category in categoriesFromCoreData {
                var newTrackers = [Tracker]()
                for tracker in category.visibleTrackers(filterString: searchText, pin: nil) {
                  //  guard let schedule = tracker.schedule else { continue }
                   // let scheduleIntegers = schedule.map { $0.numberValue }
                   // if let day = currentDate, scheduleIntegers.contains(day) {
                       // newTrackers.append(tracker)
                   // }
                }
    //            let filteredTrackersForDate: [Tracker] = category.trackers.filter { tracker in
    //                guard let schedule = tracker.schedule else { return false }
    //                let days = schedule.map { $0.rawValue }
    //                let day = days[selectedWeekday]
    //                return tracker.schedule!.contains(WeekDay(rawValue: day) ?? .monday)
    //            }
    //                guard let schedule = self.tracker?.schedule else { continue }
    //                let days = schedule.map { $0.numberValue }
    //                if let day = currentDate, days.contains(day) {
    //                   // return (tracker?.schedule?.contains(WeekDay(rawValue: days[] ?? .monday)))
    //                    //tracker in
    //                    //                guard let schedule = tracker.schedule else { continue }
    //                    //                let scheduleIntegers = schedule.map { $0.numberValue }
    //                    //                //if let day = currentDate, scheduleIntegers.contains(day) {
    //                    //
    //                    //                tracker.schedule?.contains(scheduleIntegers)
    //                }
                    
                    let nonPinnedTrackersForDate = newTrackers.filter { !$0.isPinned }
                    if !nonPinnedTrackersForDate.isEmpty {
                        filteredCategories.append(TrackerCategory(title: category.title, trackers: nonPinnedTrackersForDate))
                    }
                    let pinnedTrackersForDate = newTrackers.filter { $0.isPinned }
                    pinnedTrackers.append(contentsOf: pinnedTrackersForDate)
                }
                
                if !pinnedTrackers.isEmpty {
                    let pinnedCategory = TrackerCategory(title: "Fixed", trackers: pinnedTrackers)
                    filteredCategories.insert(pinnedCategory, at: 0)
                }
                
                return filteredCategories
            }
        }
    */
    
    
    /*
     extension TrackersViewController: FiltersViewControllerDelegate {
         func filterSelected(filter: Filters) {
             selectedFilter = filter
             searchText = ""
             
             switch filter {
                 
             case .allTrackers:
                 // reloadVisibleCategories(with: trackerCategoryStore.trackerCategories)
                 filteredTrackers()
                 
             case .completedTrackers:
                 // reloadVisibleCategories(with: trackerCategoryStore.trackerCategories)
                 //            visibleCategories = filterCompletedTrackers( trackerCategoryStore.trackerCategories)
                 //  visibleCategories = filterCompletedTrackers(filterTrackersBySelectedDate())
                 visibleCategories = categories.map { category in
                     let completedTrackers = category.trackers.filter { tracker in
                         return isTrackerCompletedOnDate(tracker: tracker, date: todaysDate)
                     }
                     return TrackerCategory(title: category.title, trackers: completedTrackers)
                 }.filter { !$0.trackers.isEmpty }
                 collectionView.reloadData()
              
                 
             case .uncompletedTrackers:
                 // reloadVisibleCategories(with: trackerCategoryStore.trackerCategories)
                 //visibleCategories = filterNotCompletedTrackers( trackerCategoryStore.trackerCategories)
                 //  visibleCategories = filterNotCompletedTrackers(filterTrackersBySelectedDate())
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
                     //            datePicker.date = Date()
                     //            dateChanged(sender: datePicker)
                     //            reloadVisibleCategories(with: trackerCategoryStore.trackerCategories)
                     //            print("\(visibleCategories.count)")
                 }
             }
         }
     */
    
    
    
    
    ////
    ////    func editTracker(id: UUID, at indexPath: IndexPath) {
    ////        //let tracker = try trackerStore.fetchTrackerByID(id: id, at: indexPath)
    ////        let editTrackerViewController = TrackerCreationScreenViewController()
    ////      //  editTrackerViewController.editTracker =
    ////        print(#function)
    ////    }
    ////
    ////    func deleteTracker(id: UUID, at indexPath: IndexPath) {
    ////       // analyticsService.reportEvent(event: "Chose delete option in tracker's context menu", parameters: ["event": "click", "screen": "Main", "item": "delete"])
    ////
    ////        let actionSheet: UIAlertController = {
    ////            let alert = UIAlertController()
    ////            alert.title = NSLocalizedString("deleteTrackerAlert.title", comment: "")
    ////            return alert
    ////        }()
    ////
    ////        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
    //////            self?.deleteTracker(<#T##tracker: Tracker##Tracker#>)
    ////            do {
    ////                try self?.trackerStore.deleteTracker(id: id, at: indexPath)
    ////                //self?.reloadData()
    ////                self?.collectionView.reloadData()
    ////            } catch {
    ////                print("Failed to delete tracker: \(error)")
    ////            }
    ////            print(#function)
    ////
    ////        }
    ////        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    ////
    ////        actionSheet.addAction(deleteAction)
    ////        actionSheet.addAction(cancelAction)
    ////
    ////        present(actionSheet, animated: true)
    ////    }
    ////
    //
    //    }
    //
    //
}
