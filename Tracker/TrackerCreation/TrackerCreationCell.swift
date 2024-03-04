//
//  TrackerCreationCell.swift
//  Tracker
//
//  Created by Игорь Мунгалов on 12.12.2023.
//

import UIKit

class TrackerCreationCell: UITableViewCell {
    
    static let id = "TrackerCreationCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray3
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private var ypChevronlImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "ypChevron")
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutViews() {
        titleLabel.addSubview(ypChevronlImage)
        titleLabel.addSubview(subtitleLabel)
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = .backgroundDay1
        NSLayoutConstraint.activate([
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 27),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -16),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 17),
            
            ypChevronlImage.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -16),
            ypChevronlImage.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            ypChevronlImage.heightAnchor.constraint(equalToConstant: 12),
            ypChevronlImage.widthAnchor.constraint(equalToConstant: 7)
        ])
    }
    
    func setTitles(with title: String, subtitle: String?) {
        titleLabel.text = title
        if let subtitle {
            subtitleLabel.text = subtitle
        }
    }
}


