//
//  TrackerFeaturesHeaderView.swift
//  Tracker
//
//  Created by Игорь Мунгалов on 14.03.2024.
//

import UIKit

final class TrackerFeaturesHeaderView: UICollectionReusableView {
    
    let header: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.textColor = .ypBlack
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(header)
        
        NSLayoutConstraint.activate([
            
            header.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 12),
            header.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            header.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12),
            header.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
