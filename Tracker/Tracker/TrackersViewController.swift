
import UIKit

class TrackersViewController: UIViewController {
   
    private var categories: [TrackerCategory] = mockCategories
    private var trackers = [Tracker]()
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    var currentDate: Date = Date()
    private var selectedDate = Date()
    
    
    //    var trackers: [Tracker] = [Tracker(id: UUID(),
    //                   title: "Поливать растения",
    //                   color: .colorSelection1,
    //                   emoji: "🌺",
    //                   schedule: [.tuesday, .saturday]),
    //           Tracker(id: UUID(),
    //                   title: "Накормить кошку",
    //                   color: .colorSelection2,
    //                   emoji: "🐈",
    //                   schedule: [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday])
    //]
    
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
        datePicker.backgroundColor = .colorSelection8
        datePicker.layer.cornerRadius = 10
        // datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.maximumDate = Date()
        datePicker.calendar.firstWeekday = 2
        NSLayoutConstraint.activate([
            datePicker.widthAnchor.constraint(equalToConstant: 100)])
        datePicker.addTarget(self,
                             action: #selector(datePickerValueChanged),
                             for: .valueChanged)
        return datePicker
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Поиск"
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.addTarget(self, action: #selector(typing), for: .valueChanged)
        //searchBar.delegate = self
        return searchBar
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
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeAddTrackerButton()
        setupRightBarButtonItem()
        layoutSubviews()
        
        navigationItem.title = navBarTitleLabel.text
        navigationController?.navigationBar.prefersLargeTitles = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //visibleCategories = categories
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
    
    @objc private func addtapped() {
        print("addtapped")
        let trackerСreatingViewController = TrackerCreatingViewController()
        trackerСreatingViewController.delegate = self
        present(trackerСreatingViewController, animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        
        // let day = Calendar.current.component(.weekday, from: sender.date)
        
        
        //let weekday_string = dateFormatter.stringFromDate(day)
        ////        currentDate = datePicker.date
        //       // collectionView.reloadData()
        //        var selectedDate = sender.date
        //
        //        //visibleCategories = []
        //        //selectedDate = datePicker.date
        //
        var calendar = Calendar.current
        let day: WeekDay
        var filterWeekDay = calendar.component(.weekday, from: datePicker.date) - 1
        if filterWeekDay > 0 {
            day = WeekDay.allCases[filterWeekDay - 1]
        } else {
            day = WeekDay.sunday
        }
        
        print(day)
        collectionView.reloadData()
        
        
        //        visibleCategories = categories.map { category in
        //            TrackerCategory(title: category.title,
        //                            trackers: category.trackers.filter { tracker in
        //                tracker.schedule?.contains { weekDay in
        //
        //                    print(weekDay.rawValue, "1")
        //                    print(filterWeekDay.description, "2")
        //                    return weekDay.rawValue == filterWeekDay.description
        //                } == true
        //            }
        //            )
        //        }
        ////        for category in categories {
        ////            var sortedTrackers = [Tracker].self
        ////
        ////            for tracker in category.trackers {
        ////                if tracker.schedule.
        ////            }
        ////        }
        //        //collectionView.reloadData()
    }
    
    
    private func reloadVisibleCategories() {
        
    }
    
    @objc private func typing() {
        print(#function)
    }
    
    private func layoutSubviews() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(whatWillWeTrackView)
        NSLayoutConstraint.activate([
            
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 24),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
//            whatWillWeTrackView.constraint(equalTo: view.leadingAnchor),
//            whatWillWeTrackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            whatWillWeTrackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            whatWillWeTrackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            whatWillWeTrackView.topAnchor.constraint(equalTo: view.topAnchor),
            whatWillWeTrackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UISearchResultsUpdating
extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
}

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    //    func numberOfSections(in collectionView: UICollectionView) -> Int {
    //      //  return visibleCategories.count
    
    //    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if visibleCategories.isEmpty {
            whatWillWeTrackView.isHidden = false
        }
        else {
            whatWillWeTrackView.isHidden = true
        }
        // return visibleCategories[section].trackers.count
        return trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackersCollectionViewCell.identifier, for: indexPath) as! TrackersCollectionViewCell
        // let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        //        let tracker = trackers[indexPath.item]
        //        cell.setupCell(with: tracker)
        cell.setupCell(with: trackers[indexPath.row])
        return cell
    }
    
    //    func collectionView(_ collectionView: UICollectionView,
    //                        viewForSupplementaryElementOfKind kind: String,
    //                        at indexPath: IndexPath) -> UICollectionReusableView {
    //        let view = collectionView.dequeueReusableSupplementaryView(
    //            ofKind: kind,
    //            withReuseIdentifier: HeaderView.id,
    //            for: indexPath) as! HeaderView
    //        //view.titleLabel.text = categories[indexPath.row].title
    //        view.titleLabel.text = categories[indexPath.section].title
    //        return view
    //    }
    
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

extension TrackersViewController: TrackersDelegate {
    func addedNew(tracker: Tracker) {
        trackers.append(tracker)
        collectionView.reloadData()
        
    }
}
