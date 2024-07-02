
import UIKit

final class StatisticViewController: UIViewController {
    
    private let trackerRecordStore = TrackerRecordStore()
    private var completedTrackers: Set<TrackerRecord> = []
    private var trackers = [Tracker]()
    
    private lazy var emptyView: StatisticsNotFoundView = {
        let view = StatisticsNotFoundView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let statisticsView = StatisticsView(title: "0", subtitle: "Трекеров завершено")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Статистика"
        setupViews()
        updateStatistics()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStatistics()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        statisticsView.frame = CGRect(x: 16, y: self.view.frame.midY - 45, width: self.view.frame.width - 32, height: 90)
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.systemBackground
        [emptyView, statisticsView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        statisticsView.frame = CGRect(x: 16, y: self.view.frame.midY, width: self.view.frame.width - 32, height: 90)
        statisticsView.setupUI()
        
        NSLayoutConstraint.activate([
            
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            statisticsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            statisticsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statisticsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            statisticsView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    private func updateStatistics() {
        do {
            completedTrackers = try trackerRecordStore.fetchRecords()
            statisticsView.configValue(value: completedTrackers.count)
            updateUI()
        } catch {
            print("Ошибка при получении записей: \(error)")
        }
    }
    
    private func updateUI() {
        if completedTrackers.isEmpty {
            emptyView.isHidden = false
            statisticsView.isHidden = true
        } else {
            emptyView.isHidden = true
            statisticsView.isHidden = false
        }
    }
}


