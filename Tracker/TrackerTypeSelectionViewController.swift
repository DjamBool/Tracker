//
//  TrackerTypeSelectionViewController.swift
//  Tracker
//
//  Created by Игорь Мунгалов on 05.12.2023.
//

import UIKit

class TrackerTypeSelectionViewController: UIViewController {

    private let createAHabit: UIButton = {
       let button = UIButton()
        button.setTitle("Привычка", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(createNewHabit), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let createIrregularEvents: UIButton = {
       let button = UIButton()
         button.setTitle("Нерегулярное событие", for: .normal)
         button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
         button.backgroundColor = .ypBlack
         button.layer.cornerRadius = 16
         button.addTarget(self, action: #selector(createNewEvent), for: .touchUpInside)
         button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Создание трекера"
        layoutSubviews()
    }
  
    
    @objc private func createNewHabit() {
        print(#function)
    }
    
    @objc private func createNewEvent() {
        print(#function)
    }
    
    private func layoutSubviews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(createAHabit)
        stackView.addArrangedSubview(createIrregularEvents)
        
        NSLayoutConstraint.activate([
            // stackView
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            // createAHabitButton
            createAHabit.heightAnchor.constraint(equalToConstant: 60),
            //createIrregularEvents
            createIrregularEvents.heightAnchor.constraint(equalToConstant: 60)
            ])
    }
}
