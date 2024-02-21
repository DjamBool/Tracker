//
//  TrackerTypeSelectionViewController.swift
//  Tracker
//
//  Created by Игорь Мунгалов on 05.12.2023.
//

import UIKit

//protocol TrackerCreatingDelegate: AnyObject {
//    func createTracker(title: String, tracker: Tracker)
//}

class TrackerTypeSelectionViewController: UIViewController {

    weak var delegate: TrackersDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Создание трекера"
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var createAHabit: UIButton = {
       let button = UIButton()
        button.setTitle("Привычка", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(createNewHabit), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var createIrregularEvents: UIButton = {
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
       // navigationItem.title = "Создание трекера"
      //  view.title = "Создание трекера"
        //navigationBar.topItem.title = "some title"
        layoutSubviews()
    }
  
    
    @objc private func createNewHabit() {
        print(#function)
        let viewController = TrackerCreationScreenViewController()
        viewController.delegate = self.delegate
        present(viewController, animated: true, completion: nil)
    }
    
    deinit {
    
        print(#function)
    }
    @objc private func createNewEvent() {
        print(#function)
       

    }
    
    private func layoutSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        stackView.addArrangedSubview(createAHabit)
        stackView.addArrangedSubview(createIrregularEvents)
        
        NSLayoutConstraint.activate([
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
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

//extension TrackerTypeSelectionViewController: TrackerCreatingDelegate {
//    func createTracker(title: String, tracker: Tracker) {
//        delegate?.addTracker(title: title, tracker: tracker)
//        print(tracker.emoji)
//        dismiss(animated: true)
//    }
    
    
//}
