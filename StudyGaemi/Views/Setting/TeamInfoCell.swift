//
//  TeamInfoCell.swift
//  StudyGaemi
//
//  Created by 신지연 on 2024/06/28.
//

import UIKit
import SnapKit
import Then

class TeamInfoCell: UITableViewCell {
    
    // MARK: - properties

    private let titleView = UIView().then {
        $0.backgroundColor = UIColor.clear
        $0.layer.borderColor = UIColor.pointOrange.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 42
    }
    
    private let circleView = UIView().then {
        $0.backgroundColor = UIColor.white
        $0.layer.borderColor = UIColor.pointOrange.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 42
    }
    
    lazy var profileView = UIImageView().then {
        $0.image = UIImage(named: "bookAnt")
        $0.contentMode = .scaleAspectFit
        //$0.backgroundColor = .pointYellow
    }
    
    let nameLabel = UILabel().then {
        $0.text = "설명"
        $0.font = UIFont(name: CustomFontType.bold.name, size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = UIColor(named: "fontBlack")
        $0.numberOfLines = 1
    }
    
    private let descriptLabel = UILabel().then {
        $0.text = "iOS개발자"
        $0.font = UIFont(name: CustomFontType.bold.name, size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .bold)
        $0.textColor = UIColor(named: "fontGray")
        $0.numberOfLines = 1
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
        self.backgroundColor = UIColor.clear
    }
    
    func configureUI() {
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(circleView)
        self.circleView.addSubview(profileView)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(descriptLabel)
    }
    
    func constraintLayout() {
        circleView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.height.width.equalTo(84)
        }
        
        profileView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.height.width.equalTo(58)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(circleView.snp.trailing).offset(20)
            make.width.equalTo(60)
        }
        
        descriptLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(nameLabel.snp.trailing)
            make.width.equalTo(65)
        }
    }
 
}
