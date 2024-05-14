//
//  NewIrregularEventViewController.swift
//  Tracker
//
//  Created by Игорь Мунгалов on 06.03.2024.
//

import UIKit

class NewIrregularEventViewController: UIViewController {
    
    weak var delegate: TrackersDelegate?
    private var selectedDays: [WeekDay] = []
    
    private var selectedEmoji: String?
    private var selectedColor: UIColor?
    var selectedEmojiIndex: Int?
    var selectedColorIndex: Int?
    
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
    
    private lazy var navBarLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Новое нерегулярное событие"
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var viewForTextFieldPlacement: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundDay1
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var eventNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .left
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.placeholder = "Введите название события"
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.delegate = self
        textField.textAlignment = .left
        textField.backgroundColor = .clear
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.masksToBounds = true
        tableView.separatorStyle = .none
        tableView.register(EventCreationCell.self,
                           forCellReuseIdentifier: EventCreationCell.identifier)
        tableView.backgroundColor = .backgroundDay1
        tableView.layer.cornerRadius = 16
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
        button.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
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
        view.backgroundColor = .white
        title = "Новое нерегулярное событие"
        tableView.delegate = self
        tableView.dataSource = self
        
        trackerFeaturesCollectionView.delegate = self
        trackerFeaturesCollectionView.dataSource = self
        setupViews()
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createTapped() {
        guard let newTrackerName = eventNameTextField.text,
              !newTrackerName.isEmpty,
              let color = selectedColor,
              let emoji = selectedEmoji else {
            return
        }
        
        let dateForEvent = WeekDay.allCases
        let newEvent = Tracker(id: UUID(),
                               title: newTrackerName,
                               color: color,
                               emoji: emoji,
                               schedule: dateForEvent)
        delegate?.addedNew(tracker: newEvent, categoryTitle: "Irregular")
        dismiss(animated: true)
    }
    
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        viewForTextFieldPlacement.addSubview(eventNameTextField)
        
        [cancelButton, createButton].forEach { stackView.addArrangedSubview($0)
            
            [viewForTextFieldPlacement, tableView, trackerFeaturesCollectionView, stackView].forEach { scrollView.addSubview($0)
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
            
            viewForTextFieldPlacement.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            viewForTextFieldPlacement.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 24),
            viewForTextFieldPlacement.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            viewForTextFieldPlacement.heightAnchor.constraint(equalToConstant: 75),
            
            eventNameTextField.leadingAnchor.constraint(equalTo: viewForTextFieldPlacement.leadingAnchor, constant: 16),
            eventNameTextField.centerYAnchor.constraint(equalTo: viewForTextFieldPlacement.centerYAnchor),
            eventNameTextField.trailingAnchor.constraint(equalTo: viewForTextFieldPlacement.trailingAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: eventNameTextField.bottomAnchor, constant: 50),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 75),
            
            trackerFeaturesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            trackerFeaturesCollectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            trackerFeaturesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            trackerFeaturesCollectionView.heightAnchor.constraint(equalToConstant: 460),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.topAnchor.constraint(equalTo: trackerFeaturesCollectionView.bottomAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 60),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -24)
        ])
    }
}

extension NewIrregularEventViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switchCreateButton()
        return true
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension NewIrregularEventViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventCreationCell.identifier, for: indexPath) as? EventCreationCell else {
            assertionFailure("Error of casting to EventCreationCell")
            return UITableViewCell()
        }
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .backgroundDay1
        cell.selectionStyle = .none
        cell.titleLabel.text = "Категория"
        cell.setTitles(subtitle: "Event")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension NewIrregularEventViewController {
    private func switchCreateButton() {
        if let text = eventNameTextField.text,
           !text.isEmpty,
           selectedColor != nil,
           selectedEmoji != nil {
            createButton.isEnabled = true
            createButton.backgroundColor = .ypBlack
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = .ypGray
        }
    }
}


// MARK: - UICollectionViewDataSource
extension NewIrregularEventViewController: UICollectionViewDataSource {
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

extension NewIrregularEventViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
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
            let cell = collectionView.cellForItem(at: indexPath) as! TrackerFeaturesCell
            selectedEmoji = emojis[indexPath.item]
            selectedEmojiIndex = indexPath.item
            cell.highlightEmoji()
            
        } else if indexPath.section == 1 {
            if let index = selectedColorIndex {
                let indexPath = IndexPath(item: index, section: 1)
                if let cell = collectionView.cellForItem(at: indexPath) as? TrackerFeaturesCell {
                    cell.clearColorSelection()
                }
            }
            let cell = collectionView.cellForItem(at: indexPath) as! TrackerFeaturesCell
            selectedColor = colors[indexPath.item]
            selectedColorIndex = indexPath.item
            cell.highlightColor()
            
        }
        switchCreateButton()
    }
}
