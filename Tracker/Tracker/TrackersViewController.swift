
import UIKit

class TrackersViewController: UIViewController {
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    private var currentDate: Date = Date()
    
    private var trackers: [Tracker] = [
            Tracker(id: UUID(),
                    title: "Поливать растения",
                    color: .colorSelection5,
                    emoji: "❤️",
                    timetable: nil)
                ]
    
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
        label.textColor = UIColor(named: "YPBlack") ?? UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 34)
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self,
                             action: #selector(datePickerValueChanged),
                             for: .valueChanged)
        return datePicker
    }()
    
    private var starImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "starImage")
        return view
    }()
    
    private var whatWillWeTrackLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Что будем отслеживать?"
        label.textColor = .blackDay
        label.font = UIFont(name: "SF Pro", size: 12)
        label.textAlignment = .center
        return label
    }()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: TrackersCollectionViewCell.cellIdentifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.id)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 6, left: 16, bottom: 24, right: 16)
        return collectionView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.categories = [TrackerCategory(title: "Домашний уют",
                                           trackers: self.trackers)]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeAddTrackerButton()
        setupRightBarButtonItem()
        makeSearchField()
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
    
    func makeSearchField() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Поиск"
        navigationItem.searchController = search
    }
    
    @objc private func addtapped() {
        print("addtapped")
        let pageАorSelectingANewTrackerType = UINavigationController(rootViewController: TrackerTypeSelectionViewController())
        present(pageАorSelectingANewTrackerType, animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
    
    private func layoutSubviews() {
        view.addSubview(starImage)
        view.addSubview(whatWillWeTrackLabel)
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            
            starImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            starImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starImage.widthAnchor.constraint(equalToConstant: 80),
            starImage.heightAnchor.constraint(equalToConstant: 80),
            
            whatWillWeTrackLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            whatWillWeTrackLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 490),
            whatWillWeTrackLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            whatWillWeTrackLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -340),
            whatWillWeTrackLabel.heightAnchor.constraint(equalToConstant: 18),
            
           collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackersCollectionViewCell.cellIdentifier, for: indexPath) as! TrackersCollectionViewCell
        let tracker = trackers[indexPath.row]
        cell.setupCell(with: tracker)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HeaderView.id,
            for: indexPath) as! HeaderView
        //view.titleLabel.text = categories[indexPath.row].title
        view.titleLabel.text = categories[indexPath.section].title
        return view
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
