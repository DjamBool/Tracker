
import UIKit

final class TrackersCollectionViewCell: UICollectionViewCell {
    weak var delegate: TrackerCollectionViewCellDelegate?
    
    private var isCompleted: Bool?
    private var trackerId: UUID?
    private var indexPath: IndexPath?
    private var isPinned: Bool = false
    
    private let plusImage = UIImage(systemName: "plus")
    private let doneImage = UIImage(named: "Done")
    
    private let analyticsService = AnalyticsService()
    
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
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private var emojiLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.backgroundColor = .ypWhite.withAlphaComponent(0.3)
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
        button.imageView?.tintColor = .ypWhite
        button.layer.cornerRadius = 17
        button.addTarget(self, action: #selector(trackerButtonTapped), for: .touchUpInside)
        button.layer.masksToBounds = true
        return button
    }()
    
    private lazy var pinImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "pin.fill")
        image.image = image.image?.withAlignmentRectInsets(UIEdgeInsets(
            top: -6,
            left: -6,
            bottom: -6,
            right: -6))
        image.tintColor = .white
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureCell(with tracker: Tracker,
                       isCompleted: Bool,
                       completedDays: Int,
                       indexPath: IndexPath)
    {
        self.trackerId = tracker.id
        self.isCompleted = isCompleted
        self.indexPath = indexPath
        self.isPinned = tracker.isPinned
        
        trackerBackgroundView.backgroundColor = tracker.color
        trackerNameLabel.text = tracker.title
        emojiLabel.text = tracker.emoji
        trackerButton.backgroundColor = tracker.color
        pinImageView.isHidden = !isPinned
        
        let counterText = convertCompletedDays(completedDays: completedDays)
        daysCounterLabel.text = counterText
        
        let image = isCompleted ? doneImage : plusImage
        trackerButton.setImage(image, for: .normal)
        
        showPin()
    }
    
    
    @objc private func trackerButtonTapped() {
        guard let trackerId = trackerId,
              let isCompleted = isCompleted,
              let indexPath = indexPath
        else {
            assertionFailure("No trackerId")
            return
        }
        
        if isCompleted {
            delegate?.uncompleteTracker(id: trackerId, at: indexPath)
        } else {
            delegate?.completeTracker(id: trackerId, at: indexPath)
        }
    }
    
    private func convertCompletedDays(completedDays: Int) -> String {
        let formattedString = String.localizedStringWithFormat(
            NSLocalizedString("StringKey", comment: ""),
            completedDays)
        return String.localizedStringWithFormat(formattedString, completedDays)
    }
    
    private func addSubviews() {
        contentView.addSubview(trackerBackgroundView)
        contentView.addSubview(daysCounterLabel)
        contentView.addSubview(trackerButton)
        
        
        [emojiLabel, trackerNameLabel, pinImageView].forEach { (trackerBackgroundView.addSubview($0)) }
        
        let interaction = UIContextMenuInteraction(delegate: self)
        trackerBackgroundView.addInteraction(interaction)
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
            trackerButton.heightAnchor.constraint(equalToConstant: 34),
            
            pinImageView.widthAnchor.constraint(equalToConstant: 24),
            pinImageView.heightAnchor.constraint(equalToConstant: 24),
            pinImageView.topAnchor.constraint(equalTo: trackerBackgroundView.topAnchor, constant: 12),
            pinImageView.trailingAnchor.constraint(equalTo: trackerBackgroundView.trailingAnchor, constant: -4)
            
        ])
    }
    
    private func showPin() {
        if self.isPinned {
            pinImageView.isHidden = false
        } else {
            pinImageView.isHidden = true
        }
    }
}


extension TrackersCollectionViewCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        guard let indexPath = indexPath else { return nil }
        
        let configContextMenu = UIContextMenuConfiguration(actionProvider: { _ in
            let pinTitle = self.isPinned ? "Открепить" : "Закрепить"
            
            let pinAction = UIAction(title: pinTitle) { _ in
                self.delegate?.pinTracker(at: indexPath)
            }
            
            let editAction = UIAction(title: NSLocalizedString("editAction.title", comment: "")) { [weak self] _ in
                guard let indexPath = self?.indexPath else {
                    return
                }
                self?.delegate?.editTracker(at: indexPath)
            }
            
            let deleteAction = UIAction(title: "Delete", attributes: .destructive) { [weak self] _ in
                guard let indexPath = self?.indexPath else {
                    return
                }
                self?.delegate?.deleteTracker(at: indexPath)
            }
            
            let actions = [pinAction, editAction, deleteAction]
            return UIMenu(title: "", children: actions)
        })
        
        return configContextMenu
    }
}
