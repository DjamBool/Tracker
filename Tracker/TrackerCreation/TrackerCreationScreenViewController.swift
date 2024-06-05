
import UIKit

class TrackerCreationScreenViewController: UIViewController {
    
    private let viewColors = Colors()
    
    weak var trackerDelegate: TrackersDelegate?
    weak var scheduleViewControllerdelegate: ScheduleViewControllerDelegate?
    
    private var day: String?
    private var selectedDays: [WeekDay] = []
    var newTracker: Tracker?
    private var trackers: [Tracker] = []
    
    private var selectedEmoji: String?
    private var selectedColor: UIColor?
    var selectedEmojiIndex: Int?
    var selectedColorIndex: Int?
    
    lazy var category: TrackerCategory? = nil {
        didSet {
            checkСontent()
        }
    }
    
    private var selectedCategoriesTitle = ""
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var viewForTextFieldPlacement: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundDay1
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var textFieldForTrackerName: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.placeholder = "Введите название трекера"
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.textAlignment = .left
        
        return textField
    }()
    
    private let createTrackerTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.masksToBounds = true
        tableView.backgroundColor = .backgroundDay1
        tableView.layer.cornerRadius = 16
        tableView.register(TrackerCreationCell.self, forCellReuseIdentifier: TrackerCreationCell.identifier)
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.ypRed, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16,
                                                    weight: .medium)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.ypRed.cgColor
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16,
                                                    weight: .medium)
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 16
        button.backgroundColor = .ypGray
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    let scheduleLabel: UILabel =  {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var trackerFeaturesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.layer.masksToBounds = true
        collectionView.isScrollEnabled = false
        
        collectionView.register(TrackerFeaturesCell.self, forCellWithReuseIdentifier: TrackerFeaturesCell.identifier)
        
        collectionView.register(TrackerFeaturesHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TrackerFeaturesHeaderView.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewColors.viewBackgroundColor
        title = "Новая привычка"
        scheduleViewControllerdelegate = self
        
        textFieldForTrackerName.delegate = self
        createTrackerTableView.delegate = self
        createTrackerTableView.dataSource = self
        
        trackerFeaturesCollectionView.dataSource = self
        trackerFeaturesCollectionView.delegate = self
        
        layout()
    }
    
    func layout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        viewForTextFieldPlacement.addSubview(textFieldForTrackerName)
        [cancelButton, createButton].forEach { stackView.addArrangedSubview($0)
            
            [viewForTextFieldPlacement, createTrackerTableView, trackerFeaturesCollectionView, stackView].forEach { scrollView.addSubview($0)
            }
        }
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            scheduleLabel.widthAnchor.constraint(equalToConstant: 150),
            scheduleLabel.heightAnchor.constraint(equalToConstant: 17),
            
            viewForTextFieldPlacement.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            viewForTextFieldPlacement.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 24),
            viewForTextFieldPlacement.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            viewForTextFieldPlacement.heightAnchor.constraint(equalToConstant: 75),
            
            textFieldForTrackerName.leadingAnchor.constraint(equalTo: viewForTextFieldPlacement.leadingAnchor, constant: 16),
            textFieldForTrackerName.centerYAnchor.constraint(equalTo: viewForTextFieldPlacement.centerYAnchor),
            textFieldForTrackerName.trailingAnchor.constraint(equalTo: viewForTextFieldPlacement.trailingAnchor),
            
            createTrackerTableView.leadingAnchor.constraint(equalTo: viewForTextFieldPlacement.leadingAnchor),
            createTrackerTableView.topAnchor.constraint(equalTo: viewForTextFieldPlacement.bottomAnchor, constant: 24),
            createTrackerTableView.trailingAnchor.constraint(equalTo: viewForTextFieldPlacement.trailingAnchor),
            createTrackerTableView.heightAnchor.constraint(equalToConstant: 150),
            
            trackerFeaturesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            trackerFeaturesCollectionView.topAnchor.constraint(equalTo: createTrackerTableView.bottomAnchor, constant: 32),
            trackerFeaturesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            trackerFeaturesCollectionView.heightAnchor.constraint(equalToConstant: 460),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.topAnchor.constraint(equalTo: trackerFeaturesCollectionView.bottomAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 60),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        guard let newTrackerName = textFieldForTrackerName.text,
              !newTrackerName.isEmpty,
              let color = selectedColor,
              let emoji = selectedEmoji else {
            return
        }
        let newTracker = Tracker(id: UUID(),
                                 title: newTrackerName,
                                 color: color,
                                 emoji: emoji,
                                 schedule: self.selectedDays)
        trackerDelegate?.addedNew(tracker: newTracker, categoryTitle: category?.title ?? "Важное")
        dismiss(animated: true)
    }
    
    private func checkСontent() {
        createButton.isEnabled = textFieldForTrackerName.text?.isEmpty == false && selectedColor != nil && selectedEmoji != nil
        if createButton.isEnabled {
            createButton.backgroundColor = .ypBlack
        } else {
            createButton.backgroundColor = .backgroundDay
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TrackerCreationScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackerCreationCell.identifier, for: indexPath) as? TrackerCreationCell else {
            assertionFailure("Error of casting to TrackerCreationCell")
            return UITableViewCell()
        }
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .backgroundDay1
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.titleLabel.text = "Категория"
            cell.setTitles(subtitle: selectedCategoriesTitle)
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }  else if indexPath.row == 1 {
            let schedule = selectedDays.isEmpty ? "" : selectedDays.map {
                $0.shortForm
            }.joined(separator: ", ")
            cell.titleLabel.text = "Расписание"
            cell.setTitles(subtitle: schedule)
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = CategoriesViewController(delegate: self, selectedCategory: category)
            present(UINavigationController(rootViewController: vc), animated: true)
            
        } else if indexPath.row == 1 {
            let viewController = ScheduleViewController()
            viewController.delegate = self
            self.scheduleViewControllerdelegate?.daysWereChosen(self.selectedDays)
            present(viewController, animated: true, completion: nil)
        }
    }
}

// MARK: - UITextFieldDelegate
extension TrackerCreationScreenViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switchCreateButton()
        return true
    }
}

// MARK: - ScheduleViewControllerDelegate
extension TrackerCreationScreenViewController: ScheduleViewControllerDelegate {
    func daysWereChosen(_ selectedDays: [WeekDay]) {
        self.selectedDays = selectedDays
        switchCreateButton()
        createTrackerTableView.reloadData()
    }
    
    func updateSchedule(_ selectedDays: [WeekDay]) {
        day = selectedDays.map { $0.shortForm }.joined(separator: ", ")
    }
}


extension TrackerCreationScreenViewController {
    private func switchCreateButton() {
        if let trackerName = textFieldForTrackerName.text,
           !trackerName.isEmpty,
           !selectedDays.isEmpty,
           selectedColor != nil,
           selectedEmoji != nil
        {
            createButton.isEnabled = true
            createButton.backgroundColor = .ypBlack
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = .ypGray
        }
    }
}

// MARK: - UICollectionViewDataSource
extension TrackerCreationScreenViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return emojis.count
        } else if section == 1 {
            return colors.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerFeaturesCell.identifier, for: indexPath) as? TrackerFeaturesCell else { assertionFailure("Error casting to TrackerFeaturesCell")
            return UICollectionViewCell()
        }
        if indexPath.section == 0 {
            let emoji = emojis[indexPath.row]
            cell.label.text = emoji
        } else if indexPath.section == 1 {
            let color = colors[indexPath.row]
            cell.label.backgroundColor = color
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackerFeaturesHeaderView.identifier, for: indexPath) as? TrackerFeaturesHeaderView else {
            assertionFailure("Could not cast to TrackerFeaturesHeaderView")
            return UICollectionReusableView()
        }
        if indexPath.section == 0 {
            view.header.text = "Emoji"
        } else if indexPath.section == 1 {
            view.header.text = "Цвет"
        }
        return view
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackerCreationScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1 //0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let index = selectedEmojiIndex {
                let indexPath = IndexPath(item: index, section: 0)
                if let cell = collectionView.cellForItem(at: indexPath) as? TrackerFeaturesCell {
                    cell.clearEmojiSelection()
                }
            }
            let cell = collectionView.cellForItem(at: indexPath) as? TrackerFeaturesCell
            selectedEmoji = emojis[indexPath.item]
            selectedEmojiIndex = indexPath.item
            cell?.highlightEmoji()
            
        } else if indexPath.section == 1 {
            if let index = selectedColorIndex {
                let indexPath = IndexPath(item: index, section: 1)
                if let cell = collectionView.cellForItem(at: indexPath) as? TrackerFeaturesCell {
                    cell.clearColorSelection()
                }
            }
            let cell = collectionView.cellForItem(at: indexPath) as? TrackerFeaturesCell
            selectedColor = colors[indexPath.item]
            selectedColorIndex = indexPath.item
            cell?.highlightColor()
            
        }
        switchCreateButton()
    }
}

extension TrackerCreationScreenViewController: CategoriesViewModelDelegate {
    func didSelectCategory(category: TrackerCategory) {
        self.category = category
        let categoryTitle = category.title
        selectedCategoriesTitle = categoryTitle
        createTrackerTableView.reloadData()
    }
}
