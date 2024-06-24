//
//  BadgeViewCell.swift
//  StudyGaemi
//
//  Created by 신지연 on 2024/06/03.
//

import UIKit
import SnapKit
import Then

class BadgeViewCell: UITableViewCell {
    
    // MARK: - properties
    private let backView = UIView().then {
        $0.backgroundColor = UIColor(named: "viewBackgroundColor2")
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.15
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        $0.layer.shadowRadius = 3
        $0.layer.cornerRadius = 8
    }
    
    private lazy var antImageView = UIImageView().then {
        $0.image = UIImage(named: "bookAnt")
        $0.contentMode = .scaleAspectFit
    }
    
    private let straightBackView = UIView().then() {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .pointOrange
    }
    
    private let straightLabel = UILabel().then {
        $0.font = UIFont(name: CustomFontType.bold.name, size: 10) ?? UIFont.systemFont(ofSize: 10, weight: .bold)
        $0.textColor = .white
    }
    
    private lazy var badgeTitleLabel = UILabel().then {
        $0.font = UIFont(name: CustomFontType.bold.name, size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    private let dateLabel = UILabel().then {
        $0.font = UIFont(name: CustomFontType.bold.name, size: 10) ?? UIFont.systemFont(ofSize: 10, weight: .bold)
        $0.textColor = .lightGray
    }
    
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
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0))
        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0).cgColor
        contentView.layer.borderWidth = 0
        contentView.backgroundColor = .clear
//        contentView.layer.shadowColor = UIColor.black.cgColor
//        contentView.layer.shadowOpacity = 0.25
//        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        contentView.layer.shadowRadius = 5
        
    }
    
    func configureUI() {
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(backView)
        self.backView.addSubview(antImageView)
        self.backView.addSubview(badgeTitleLabel)
        self.backView.addSubview(straightBackView)
        self.straightBackView.addSubview(straightLabel)
        self.backView.addSubview(dateLabel)
        
    }
    
    func constraintLayout() {
        backView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
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
