//
//  WhatWillWeTrackView.swift
//  Tracker
//
//  Created by Игорь Мунгалов on 27.02.2024.
//

import UIKit

final class WhatWillWeTrackView: UIView {
        
    private var starImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "starImage")
        return view
    }()
    
    private var whatWillWeTrackLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Что будем отслеживать?"
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [starImage, whatWillWeTrackLabel].forEach { self.addSubview($0)
        }
        NSLayoutConstraint.activate([
            starImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            starImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            starImage.widthAnchor.constraint(equalToConstant: 80),
            starImage.heightAnchor.constraint(equalToConstant: 80),
            
            whatWillWeTrackLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            whatWillWeTrackLabel.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8),
            whatWillWeTrackLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            whatWillWeTrackLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
