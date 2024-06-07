
import UIKit

protocol StatisticViewControllerDelegate: AnyObject {
    func updateStatistics()
}

class StatisticViewController: UIViewController {

    private let trackerRecordStore = TrackerRecordStore()
    private var completedTrackers: [TrackerRecord] = []
    weak var delegate: StatisticViewControllerDelegate?

    private lazy var emptyView: StatisticsNotFoundView = {
        let view = StatisticsNotFoundView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.colorSelection1.cgColor,
            UIColor.colorSelection3.cgColor,
            UIColor.colorSelection5.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        return gradientLayer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Статистика"
        setupViews()
        emptyView.isHidden = true
    }
    
    func setupViews() {
        [titleLabel, subtitleLabel].forEach { containerView.addSubview($0) }
        [emptyView, containerView].forEach { view.addSubview($0) }
            
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        
            NSLayoutConstraint.activate([
                
                emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                emptyView.topAnchor.constraint(equalTo: view.topAnchor),
                emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
                containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 206),
                containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                containerView.heightAnchor.constraint(equalToConstant: 90),
                
                titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
                titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
                titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
                titleLabel.heightAnchor.constraint(equalToConstant: 41),
                
                subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
                subtitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
                subtitleLabel.heightAnchor.constraint(equalToConstant: 18),
            ])
        }
    }
   

