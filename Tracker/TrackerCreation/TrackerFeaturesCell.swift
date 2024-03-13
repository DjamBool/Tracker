//
//  TrackerFeaturesCell.swift
//  Tracker
//
//  Created by Игорь Мунгалов on 13.03.2024.
//

import UIKit

final class TrackerFeaturesCell: UICollectionViewCell {
    lazy var view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }
}
