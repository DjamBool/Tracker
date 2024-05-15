
import UIKit

class TrackersViewController: UIViewController {
    
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    var myCurrentDate: Date = Date()
    private var currentDate: Int?
    private var searchText: String = ""
    
    private let trackerCategoryStore = TrackerCategoryStore.shared
    private let trackerRecordStore = TrackerRecordStore.shared
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    private var navBarTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Трекеры"
        label.textColor = .ypBlack
        label.font = UIFont.boldSystemFont(ofSize: 34)
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.clipsToBounds = true
        datePicker.layer.cornerRadius = 10
        datePicker.setValue(UIColor.white, forKey: "textColor")
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
        textField.backgroundColor = .ypLightGray
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadVisibleCategories()
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        setWeekDay()
        makeAddTrackerButton()
        setupRightBarButtonItem()
        layoutSubviews()
        
        navigationItem.title = navBarTitleLabel.text
        navigationController?.navigationBar.prefersLargeTitles = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        do {
            completedTrackers = try trackerRecordStore.fetchTrackerRecords()
        } catch {
            print("Error with fetchTrackers: \(error.localizedDescription)")
        }
        
        trackerCategoryStore.delegate = self
        
    }
    
    private func makeAddTrackerButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self, action: #selector(addtapped))
        addButton.tintColor = .black
        navigationItem.leftBarButtonItem = addButton
    }
    
    private func setupRightBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func addtapped() {
        let trackerСreatingViewController = TrackerCreatingViewController()
        trackerСreatingViewController.delegate = self
        present(trackerСreatingViewController, animated: true)
    }
    
    @objc func dateChanged(sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.weekday], from: sender.date)
        if let day = components.weekday {
            currentDate = day
            reloadVisibleCategories()
        }
    }
    
    private func setWeekDay() {
        let components = Calendar.current.dateComponents([.weekday], from: Date())
        currentDate = components.weekday
        print("\(String(describing: currentDate))")
    }
    
    private func reloadVisibleCategories() {
        var newCategories = [TrackerCategory]()
        visibleCategories = trackerCategoryStore.trackerCategories
        
        for category in visibleCategories {
            var newTrackers = [Tracker]()
            for tracker in category.visibleTrackers(filterString: searchText) {
                guard let schedule = tracker.schedule else { return }
                let scheduleIntegers = schedule.map { $0.numberValue }
                if let day = currentDate, scheduleIntegers.contains(day) && (
                    searchText.isEmpty ||
                    tracker.title.lowercased().contains(searchText.lowercased())
                ) {
                    newTrackers.append(tracker)
                }
            }
            
            if newTrackers.count > 0 {
                let newCategory = TrackerCategory(
                    title: category.title,
                    trackers: newTrackers
                )
                newCategories.append(newCategory)
            }
        }
        visibleCategories = newCategories
        collectionView.reloadData()
    }
    
    private func showNothingWasFoundView() {
        if !categories.isEmpty && visibleCategories.isEmpty {
            nothingWasFoundView.isHidden = false
        } else {
            nothingWasFoundView.isHidden = true
        }
    }
    
    private func layoutSubviews() {
        view.addSubview(searchTextField)
        view.addSubview(collectionView)
        view.addSubview(whatWillWeTrackView)
        view.addSubview(nothingWasFoundView)
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
            nothingWasFoundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
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
        
        cell.delegate = self
        
        let isCompletedToday = isTrackerCompletedToday (id: tracker.id)
        let completedDays = completedTrackers.filter { $0.id == tracker.id }.count
        cell.setupCell(with: tracker,
                       isCompleted: isCompletedToday,
                       completedDays: completedDays,
                       indexPath: indexPath)
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

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
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

extension TrackersViewController: TrackersDelegate {
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
        dismiss(animated: true)
        reloadVisibleCategories()
    }
}

// MARK: -TrackerCollectionViewCellDelegate

extension TrackersViewController: TrackerCollectionViewCellDelegate {
    func competeTracker(id: UUID, indexPath: IndexPath) {
        if datePicker.date <= Date() {
            let record = TrackerRecord(id: id, date: datePicker.date)
            completedTrackers.append(record)
            try? trackerRecordStore.addNewTracker(record)
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
    func uncompleteTracker(id: UUID, indexPath: IndexPath) {
        //        if let index = completedTrackers.firstIndex(where: { trackerRecord in
        //            trackerRecord.id == id //&&
        //           // trackerRecord.date == datePicker.date
        //        }) {
        //            //completedTrackers.remove(at: index)
        //            completedTrackers.removeAll { trackerRecord in
        //                isSameTracker(trackerRecord: trackerRecord, id: id)
        //            }
        //            try? trackerRecordStore.deleteTrackerRecord(TrackerRecord(id: id, date: datePicker.date))
        //        }
        //        collectionView.reloadItems(at: [indexPath])
        //    }
        
        
        completedTrackers.removeAll { trackerRecord in
            isSameTracker(trackerRecord: trackerRecord, id: id)
        }
        if let record = trackerRecordStore.fetchRecord(by: id, and: datePicker.date) {
            try? trackerRecordStore.deleteTrackerRecord(record)
            
            
        }
        collectionView.reloadItems(at: [indexPath])
    }
}
//    func competeTracker(id: UUID, indexPath: IndexPath) {
//        guard datePicker.date <= Date() else { return }
//        let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
//        completedTrackers.append(trackerRecord)
//        collectionView.reloadItems(at: [indexPath])
//    }
//    
//    func uncompleteTracker(id: UUID, indexPath: IndexPath) {
//        completedTrackers.removeAll { trackerRecord in
//            isSameTracker(trackerRecord: trackerRecord, id: id)
//        }
//        collectionView.reloadItems(at: [indexPath])
//    }
//}

// MARK: - UITextFieldDelegate

extension TrackersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        searchText = searchTextField.text ?? ""
        showNothingWasFoundView()
        visibleCategories = trackerCategoryStore.predicateFetch(trackerTitle: searchText)
        
        reloadVisibleCategories()
        return true
    }
}

extension TrackersViewController: TrackerCategoryStoreDelegate {
    func store(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate) {
        visibleCategories = trackerCategoryStore.trackerCategories
        collectionView.reloadData()
    }
}

