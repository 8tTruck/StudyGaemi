//
//  BadgeViewCell.swift
//  StudyGaemi
//
//  Created by 신지연 on 2024/06/03.
//

import UIKit

class BadgeViewCell: UITableViewCell {
    
    // MARK: - properties
    private lazy var antImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "bookAnt")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let straightBackView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .pointOrange
        return view
    }()
    
    private let straightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFontType.bold.name, size: 10) ?? UIFont.systemFont(ofSize: 10, weight: .bold)
        label.textColor = .white
        label.text = "10일 연속"
        return label
    }()
    
    private lazy var badgeTitleLabel: UILabel = {
        let view = UILabel()
        //view.text = "공부개미 달성"
        view.font = UIFont(name: CustomFontType.bold.name, size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
        return view
    }()
    
    private let dateLabel: UILabel = {
        let view = UILabel()
        view.text = "24.05"
        view.font = UIFont(name: CustomFontType.bold.name, size: 10) ?? UIFont.systemFont(ofSize: 10, weight: .bold)
        view.textColor = .lightGray
        return view
    }()
    
    // MARK: - methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        constraintLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        // 테이블 뷰 셀 사이의 간격
        super.layoutSubviews()
        self.backgroundColor = .clear
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0))
        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0).cgColor
        contentView.layer.borderWidth = 1
        
    }
    
    func configureUI() {
        self.contentView.backgroundColor = UIColor(named: "viewBackgroundColor")
        
        self.contentView.addSubview(antImageView)
        self.contentView.addSubview(badgeTitleLabel)
        self.contentView.addSubview(straightBackView)
        self.straightBackView.addSubview(straightLabel)
        self.contentView.addSubview(dateLabel)
        
    }
    
    func constraintLayout() {
        antImageView.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(51)
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
        }
        
        badgeTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(antImageView.snp.trailing).offset(20)
            make.trailing.bottom.equalToSuperview().inset(16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16)
            make.width.equalTo(30)
        }
        
        straightBackView.snp.makeConstraints { make in
            make.leading.equalTo(antImageView.snp.trailing).offset(20)
            make.top.equalToSuperview().inset(16)
            make.width.equalTo(56)
            make.height.equalTo(20)
        }
        
        straightLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func bind(yearAndMonth: String, days: Int, ant: String){
        dateLabel.text = yearAndMonth
        straightLabel.text = "\(days)일 연속"
        badgeTitleLabel.text = ant
        switch ant {
        case "완벽개미 달성" :
            antImageView.image = .kingAnt
        case "공부개미 달성" :
            antImageView.image = .bookAnt
        case "기상개미 달성" :
            antImageView.image = .heartAnt
        default:
            antImageView.image = .heartAnt
        }
    }
}
