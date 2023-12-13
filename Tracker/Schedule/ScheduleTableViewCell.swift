//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Игорь Мунгалов on 11.12.2023.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    static let id = "ScheduleCell"
    
    let label: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.text = "ыыыыы"
        return label
    }()
    
    let toggle: UISwitch = {
       let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.onTintColor = .green
        toggle.addTarget(self, action: #selector(switchЕoggle), for: .valueChanged)
        return toggle
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(toggle)
        contentView.addSubview(label)
        contentView.backgroundColor = .systemGray4
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func switchЕoggle() {
        print("toggle Tapped")
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.heightAnchor.constraint(equalToConstant: 22),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            toggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26),
            toggle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

