//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Игорь Мунгалов on 11.12.2023.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    private lazy var scheduleTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.id)
        tableView.layer.cornerRadius = 16
        return tableView
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16,
                                                    weight: .medium)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(named: "YP Black")
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Создание трекера"
        layoutViews()
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        
    }
    
    @objc private func doneButtonTapped() {
        print(#function)
    }
    
    private func layoutViews() {
        view.addSubview(scheduleTableView)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
        
            scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 127),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scheduleTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -108),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24),
            
            
        ])
    }
    
}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.id, for: indexPath) as! ScheduleTableViewCell
        
        let day = WeekDay.allCases[indexPath.row]
        
        return cell
    }
    
    
}
