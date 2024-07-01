
import UIKit

class ScheduleTableViewCell: UITableViewCell {
    
    weak var delegate: ScheduleCellDelegate?
    private var weekDay: WeekDay?
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private lazy var toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.onTintColor = .colorSelection3
        toggle.addTarget(self, action: #selector(toggleSwitch), for: .valueChanged)
        return toggle
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(toggle)
        contentView.addSubview(label)
        contentView.backgroundColor = .backgroundDay1
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func toggleSwitch(_ sender: UISwitch) {
        guard let weekDay = weekDay else { return }
        delegate?.toggleWasSwitched(to: sender.isOn, for: weekDay)
    }
    
    func configureCell(weekDay: WeekDay, isOn: Bool) {
        self.weekDay = weekDay
        label.text = weekDay.rawValue
        toggle.isOn = isOn
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.heightAnchor.constraint(equalToConstant: 22),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            toggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26),
            toggle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

