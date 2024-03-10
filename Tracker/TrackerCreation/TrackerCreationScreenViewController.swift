//
//  TrackerCreationViewController.swift
//  Tracker
//
//  Created by Игорь Мунгалов on 08.12.2023.
//

import UIKit

class TrackerCreationScreenViewController: UIViewController {
    
    weak var trackerDelegate: TrackersDelegate?
    weak var scheduleViewControllerdelegate: ScheduleViewControllerDelegate?
    
    private var day: String?
    private var selectedDays: [WeekDay] = []
    var newTracker: Tracker?
    private var trackers: [Tracker] = []
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Новая привычка"
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        scheduleViewControllerdelegate = self
        
        textFieldForTrackerName.delegate = self
        createTrackerTableView.delegate = self
        createTrackerTableView.dataSource = self
        layout()
    }
    
    func layout() {
        
        viewForTextFieldPlacement.addSubview(textFieldForTrackerName)
        view.addSubview(viewForTextFieldPlacement)
        view.addSubview(createTrackerTableView)
        view.addSubview(stackView)
        view.addSubview(titleLabel)
        
        [cancelButton, createButton].forEach { stackView.addArrangedSubview($0) }
        NSLayoutConstraint.activate([
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scheduleLabel.widthAnchor.constraint(equalToConstant: 150),
            scheduleLabel.heightAnchor.constraint(equalToConstant: 17),
            
            viewForTextFieldPlacement.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            viewForTextFieldPlacement.topAnchor.constraint(equalTo: view.topAnchor, constant: 126),
            viewForTextFieldPlacement.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            viewForTextFieldPlacement.heightAnchor.constraint(equalToConstant: 75),
            
            textFieldForTrackerName.leadingAnchor.constraint(equalTo: viewForTextFieldPlacement.leadingAnchor, constant: 16),
            textFieldForTrackerName.centerYAnchor.constraint(equalTo: viewForTextFieldPlacement.centerYAnchor),
            textFieldForTrackerName.trailingAnchor.constraint(equalTo: viewForTextFieldPlacement.trailingAnchor),
            
            createTrackerTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            createTrackerTableView.topAnchor.constraint(equalTo: textFieldForTrackerName.bottomAnchor, constant: 50),
            createTrackerTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            createTrackerTableView.heightAnchor.constraint(equalToConstant: 150),
            
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            stackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
        print(#function)
    }
    
    @objc private func createButtonTapped() {
        guard let newTrackerName = textFieldForTrackerName.text, !newTrackerName.isEmpty else { return }
        let newTracker = Tracker(id: UUID(),
                                 title: newTrackerName,
                                 color: myColors.randomElement() ?? .colorSelection3,
                                 emoji: myEmoji.randomElement() ?? "🌞",
                                 schedule: self.selectedDays)
        trackerDelegate?.addedNew(tracker: newTracker, categoryTitle: "Важное")
        dismiss(animated: true)
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
            cell.setTitles(subtitle: "Важное")
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
            print("Категория")
            let vc = AddCategoryViewController()
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
       // reloadVisibleCategories()
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
        if let trackerName = textFieldForTrackerName.text, !trackerName.isEmpty, !selectedDays.isEmpty {
                createButton.isEnabled = true
                createButton.backgroundColor = .ypBlack
            } else {
                createButton.isEnabled = false
                createButton.backgroundColor = .ypGray
            }
        }
    }

