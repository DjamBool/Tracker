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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        layout()
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
        print(#function)
    }
    
    @objc private func createButtonTapped() {
        guard let newTrackerName = eventNameTextField.text, !newTrackerName.isEmpty else { return }
        let currentDate = Date()
        let weekDay = Calendar.current.component(.weekday, from: currentDate) - 1
      //  let sss =  Calendar.current.component(.day, from: currentDate)
        let dateForEvent = WeekDay.allCases.filter { day in
            if weekDay > 0 {
                day == WeekDay.allCases[weekDay - 1]
            } else {
                day == WeekDay.sunday
            }
        }
        
        let newTracker = Tracker(id: UUID(),
                                 title: newTrackerName,
                                 color: myColors.randomElement() ?? .colorSelection3,
                                 emoji: myEmoji.randomElement() ?? "🌞",
                                 schedule: dateForEvent)
            delegate?.addedNew(tracker: newTracker, categoryTitle: "Irregular")
    dismiss(animated: true)
    }
    
    func layout() {
        
        viewForTextFieldPlacement.addSubview(eventNameTextField)
        view.addSubview(navBarLabel)
        view.addSubview(viewForTextFieldPlacement)
        view.addSubview(tableView)
        view.addSubview(stackView)
        
        [cancelButton, createButton].forEach { stackView.addArrangedSubview($0) }

        NSLayoutConstraint.activate([
            
            navBarLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBarLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBarLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            navBarLabel.heightAnchor.constraint(equalToConstant: 22),
            navBarLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                       
            viewForTextFieldPlacement.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            viewForTextFieldPlacement.topAnchor.constraint(equalTo: view.topAnchor, constant: 126),
            viewForTextFieldPlacement.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            viewForTextFieldPlacement.heightAnchor.constraint(equalToConstant: 75),
            
            eventNameTextField.leadingAnchor.constraint(equalTo: viewForTextFieldPlacement.leadingAnchor, constant: 16),
            eventNameTextField.centerYAnchor.constraint(equalTo: viewForTextFieldPlacement.centerYAnchor),
            eventNameTextField.trailingAnchor.constraint(equalTo: viewForTextFieldPlacement.trailingAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: eventNameTextField.bottomAnchor, constant: 50),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 75),
            
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),  
            stackView.heightAnchor.constraint(equalToConstant: 60)
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
        if let text = eventNameTextField.text {
            if !text.isEmpty {
                createButton.isEnabled = true
                createButton.backgroundColor = .ypBlack
            } else {
                createButton.isEnabled = false
                createButton.backgroundColor = .ypGray
            }
        }
    }
}

