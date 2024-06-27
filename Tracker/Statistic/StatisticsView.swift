
import UIKit

class StatisticsView: UIView {

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
    
    init(title: String, subtitle: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        subtitleLabel.text = subtitle
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configValue(value: Int) {
        titleLabel.text = String(value)
    }
    
    func setupUI() {
        layer.cornerRadius = 15
        addGradienBorder(colors: [.red, .green, .blue])
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        [titleLabel, subtitleLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        clipsToBounds = true
        
        NSLayoutConstraint.activate([
            containerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 1),
            containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -1),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 1),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12),
            
            subtitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            subtitleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12),
        ])
    }
    
    func addGradienBorder(colors: [UIColor], width: CGFloat = 2) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        let shape = CAShapeLayer()
        shape.lineWidth = width
        shape.path = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        layer.addSublayer(gradient)
    }
}
