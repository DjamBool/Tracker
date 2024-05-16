//
//  TrackerFeaturesCell.swift
//  Tracker
//
//  Created by Игорь Мунгалов on 13.03.2024.
//

import UIKit

final class TrackerFeaturesCell: UICollectionViewCell {
//    lazy var view: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.masksToBounds = true
//        view.layer.cornerRadius = 8
//        return view
//    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 32)
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
//            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
//            label.topAnchor.constraint(equalTo: topAnchor),
//            label.bottomAnchor.constraint(equalTo: bottomAnchor)
            
//            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func highlightEmoji() {
        contentView.backgroundColor = .ypLightGray
        contentView.layer.cornerRadius = 16
    }
    
    func highlightColor() {
        layer.borderWidth = 3
        layer.borderColor = label.backgroundColor?.withAlphaComponent(0.3).cgColor
        layer.cornerRadius = 8
    }
    
    func clearColorSelection() {
        layer.borderWidth = 0
    }
    func clearEmojiSelection() {
        contentView.backgroundColor = .clear
    }
}
