//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Игорь Мунгалов on 06.12.2023.
//

import UIKit

final class TrackersCollectionViewCell: UICollectionViewCell {
    weak var delegate: TrackerCollectionViewCellDelegate?
    
    private var trackersModel = [Tracker]()
    private var isCompleted: Bool = false
    private var trackerId: UUID?
    private var indexPath: IndexPath?
    
    private let plusImage = UIImage(systemName: "plus")
    private let doneImage = UIImage(named: "Done")
    
    private var trackerBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private var trackerNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private var emojiLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.backgroundColor = .white.withAlphaComponent(0.3)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 12
        return label
    }()
    
    private var daysCounterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "0 days"
        return label
    }()
    
    private lazy var trackerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(plusImage, for: .normal)
        button.imageView?.tintColor = .white
        button.layer.cornerRadius = 17
        button.addTarget(self, action: #selector(trackerButtonTapped), for: .touchUpInside)
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        layout()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupCell(with tracker: Tracker,
                   isCompleted: Bool,
                   completedDays: Int,
                   indexPath: IndexPath) {
        self.trackerId = tracker.id
        self.isCompleted = isCompleted
        self.indexPath = indexPath
        
        trackerBackgroundView.backgroundColor = tracker.color
        trackerNameLabel.text = tracker.title
        emojiLabel.text = tracker.emoji
        trackerButton.backgroundColor = tracker.color
        
        let counterText = convertCompletedDays(completedDays: completedDays)
        daysCounterLabel.text = counterText
        
        let image = isCompleted ? doneImage : plusImage
        trackerButton.setImage(image, for: .normal)
    }
    
    @objc private func trackerButtonTapped() {
        guard let trackerId = trackerId, let indexPath = indexPath else {
            assertionFailure("No trackerId")
            return
        }
        if isCompleted {
            delegate?.uncompleteTracker(id: trackerId, indexPath: indexPath)
        } else {
            delegate?.competeTracker(id: trackerId, indexPath: indexPath)
        }
    }
    
    private func convertCompletedDays(completedDays: Int) -> String {
        let remainder10 = completedDays % 10
        let remainder100 = completedDays % 100
        
        if remainder10 == 1 && remainder100 != 11 {
            return "\(completedDays) день"
        } else if remainder10 >= 2 &&
                    remainder10 <= 4 &&
                    (remainder100 < 10 || remainder100 >= 20) {
            return "\(completedDays) дня"
        } else {
            return "\(completedDays) дней"
        }
    }
    
    private func addSubviews() {
        contentView.addSubview(trackerBackgroundView)
        contentView.addSubview(daysCounterLabel)
        contentView.addSubview(trackerButton)
        
        trackerBackgroundView.addSubview(emojiLabel)
        trackerBackgroundView.addSubview(trackerNameLabel)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            
            trackerBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackerBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trackerBackgroundView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiLabel.leadingAnchor.constraint(equalTo: trackerBackgroundView.leadingAnchor, constant: 12),
            emojiLabel.topAnchor.constraint(equalTo: trackerBackgroundView.topAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            
            trackerNameLabel.leadingAnchor.constraint(equalTo: trackerBackgroundView.leadingAnchor, constant: 12),
            trackerNameLabel.trailingAnchor.constraint(equalTo: trackerBackgroundView.trailingAnchor, constant: -12),
            trackerNameLabel.bottomAnchor.constraint(equalTo: trackerBackgroundView.bottomAnchor, constant: -12),
            
            daysCounterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            daysCounterLabel.topAnchor.constraint(equalTo: trackerBackgroundView.bottomAnchor, constant: 16),
            daysCounterLabel.widthAnchor.constraint(equalToConstant: 101),
            daysCounterLabel.heightAnchor.constraint(equalToConstant: 18),
            
            trackerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            trackerButton.topAnchor.constraint(equalTo: trackerBackgroundView.bottomAnchor, constant: 8),
            trackerButton.widthAnchor.constraint(equalToConstant: 34),
            trackerButton.heightAnchor.constraint(equalToConstant: 34)
            
        ])
    }
}
