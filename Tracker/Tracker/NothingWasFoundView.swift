//
//  NothingWasFoundView.swift
//  Tracker
//
//  Created by Игорь Мунгалов on 27.02.2024.
//

import UIKit

final class NothingWasFoundView: UIView {
    
    private lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "serchEmoji")
        return imageView
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.black
        label.text = "Ничего не найдено"
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
        [image, label].forEach { self.addSubview($0)
        }
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            image.widthAnchor.constraint(equalToConstant: 80),
            image.heightAnchor.constraint(equalToConstant: 80),
            
            label.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            label.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
}
