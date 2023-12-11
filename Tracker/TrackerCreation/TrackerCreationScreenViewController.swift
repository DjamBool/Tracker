//
//  TrackerCreationViewController.swift
//  Tracker
//
//  Created by Игорь Мунгалов on 08.12.2023.
//

import UIKit

class TrackerCreationScreenViewController: UIViewController {

    private let nameOfTrackertableViewTextField: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private let createTrackerTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Новая привычка"
     
    }

}
