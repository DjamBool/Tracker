//
//  TrackerCreationViewController.swift
//  Tracker
//
//  Created by Игорь Мунгалов on 08.12.2023.
//

import UIKit

class TrackerCreationScreenViewController: UIViewController {

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
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let textFieldForTrackerName: UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .backgroundDay1
        textField.placeholder = "Введите название трекера"
        textField.textColor = .ypBlack
        textField.font = UIFont.systemFont(ofSize: 22)
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.textAlignment = .left

        return textField
    }()
    
    private let createTrackerTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .ypGray
        tableView.layer.cornerRadius = 16
        tableView.backgroundColor = .systemGray5
        tableView.register(TrackerCreationCell.self, forCellReuseIdentifier: TrackerCreationCell.id)
        tableView.separatorStyle = .singleLine

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
        button.backgroundColor = .systemGray4
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        textFieldForTrackerName.delegate = self
        createTrackerTableView.delegate = self
        createTrackerTableView.dataSource = self
        layout()
    }

    func layout() {
        
        viewForTextFieldPlacement.addSubview(textFieldForTrackerName)
        view.addSubview(viewForTextFieldPlacement)
        view.addSubview(createTrackerTableView)

        view.addSubview(createButton)
        view.addSubview(cancelButton)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            
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
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalToConstant: 160),
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),

            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalToConstant: 160),
            createButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34)
        ])
    }
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
        print(#function)
    }
    
    @objc private func createButtonTapped() {
        print(#function)
    }
}


extension TrackerCreationScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackerCreationCell.id, for: indexPath) as! TrackerCreationCell
        
        if indexPath.row == 0 {
            cell.setTitle(with: "Категория")
        }  else if indexPath.row == 1 {
            cell.setTitle(with: "Расписание")
        }
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        cell.selectionStyle = .none
        
        //cell.accessoryView = UIImageView(image: UIImage(named: "ypChevron"))
//        let imageView = UIImageView(image: UIImage(named: "ypChevron"))
//        cell.accessoryView = imageView
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
            present(viewController, animated: true, completion: nil)
        }
    }   
}

extension TrackerCreationScreenViewController: UITextFieldDelegate {
    @objc private func textFieldDidChange(_ textField: UITextField) {
        print(#function)
    }
}
