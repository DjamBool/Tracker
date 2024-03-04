
import UIKit

class TrackersViewController: UIViewController {
    
    private var categories: [TrackerCategory] = []
    private var trackers = [Tracker]()
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
   // var currentDate: Date = .init() //Date()
    //private var selectedDate = Date()
    
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
        datePicker.calendar.firstWeekday = 2
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
        collectionView.contentInset = UIEdgeInsets(top: 6, left: 16, bottom: 24, right: 16)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        makeAddTrackerButton()
        setupRightBarButtonItem()
        layoutSubviews()
        
        navigationItem.title = navBarTitleLabel.text
        navigationController?.navigationBar.prefersLargeTitles = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
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
    
    private func reloadData() {
        categories = mockCategories
        dateChanged()
    }
    
    @objc private func addtapped() {
        print("addtapped")
        let trackerСreatingViewController = TrackerCreatingViewController()
        trackerСreatingViewController.delegate = self
        present(trackerСreatingViewController, animated: true)
    }
    
    @objc func dateChanged() {
        reloadVisibleCategories()
    }
    
    private func reloadVisibleCategories() {
        let calendar = Calendar.current
        let filterWeekDay = calendar.component(.weekday, from: datePicker.date) - 1
        let filterText = (searchTextField.text ?? "").lowercased()
        
        visibleCategories = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let textCondition = filterText.isEmpty ||
                tracker.title.lowercased().contains(filterText)
                let dateCondition = tracker.schedule.contains { weekDay in
                    if filterWeekDay > 0 {
                        weekDay == WeekDay.allCases[filterWeekDay - 1]
                    } else {
                        weekDay == WeekDay.sunday
                    }
                }
                return textCondition && dateCondition
            }
            
            if trackers.isEmpty {
                return nil
            }
            
            return  TrackerCategory(
                title: category.title,
                trackers: trackers
            )
        }
        collectionView.reloadData()
        showNothingWasFoundView()
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
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 24),
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
            whatWillWeTrackView.isHidden = true
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
            for: indexPath) as? HeaderView else {  fatalError("Error in converting to a HeaderView") }
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
        return CGSize(width: 167, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10,
                            left: 0,
                            bottom: 16,
                            right: 0)
    }
}

// MARK: - TrackersDelegate

extension TrackersViewController: TrackersDelegate {
    func addedNew(tracker: Tracker, categoryTitle: String) {
        if visibleCategories.isEmpty {
            let newCategory = TrackerCategory(title: categoryTitle, trackers: [tracker])
            visibleCategories.append(newCategory)
        } else {
            if let existingCategoryIndex = visibleCategories.firstIndex(where: { $0.title == categoryTitle }) {
                var updatedTrackers = visibleCategories[existingCategoryIndex].trackers
                updatedTrackers.append(tracker)
                visibleCategories[existingCategoryIndex] = TrackerCategory(title: categoryTitle, trackers: updatedTrackers)
            } else {
                let newCategory = TrackerCategory(title: categoryTitle, trackers: [tracker])
                visibleCategories.append(newCategory)
            }
        }
        self.trackers.append(tracker)
        collectionView.reloadData()
        dismiss(animated: true)
    }
}

// MARK: -TrackerCollectionViewCellDelegate

extension TrackersViewController: TrackerCollectionViewCellDelegate {
    func competeTracker(id: UUID, indexPath: IndexPath) {
        guard datePicker.date <= Date() else { return }
        let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
        completedTrackers.append(trackerRecord)
        collectionView.reloadItems(at: [indexPath])
    }
    
    func uncompleteTracker(id: UUID, indexPath: IndexPath) {
        completedTrackers.removeAll { trackerRecord in
            isSameTracker(trackerRecord: trackerRecord, id: id)
        }
        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - UITextFieldDelegate

extension TrackersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        reloadVisibleCategories()
        return true
    }
}

