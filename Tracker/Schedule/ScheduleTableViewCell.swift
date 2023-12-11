//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Игорь Мунгалов on 11.12.2023.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    static let id = "ScheduleTableViewCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private lazy var toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = .ypBlue
        toggle.addTarget(self, action: #selector(toggleSwitched), for: .valueChanged)
        
        return toggle
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func toggleSwitched() {
        print("toggle Tapped")
    }
    
    private func layoutViews() {
        [titleLabel, toggle].forEach {contentView.addSubview($0)}
        
        NSLayoutConstraint.activate([
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 27),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            toggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            toggle.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
            ])
    }
    
}
