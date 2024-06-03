//
//  BadgeViewCell.swift
//  StudyGaemi
//
//  Created by 신지연 on 2024/06/03.
//

import UIKit

class BadgeViewCell: UITableViewCell {
    
    lazy var antImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "bookAnt")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var straightView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var badgeTitleLabel: UILabel = {
        let view = UILabel()
        view.text = "공부개미 달성"
        view.font = UIFont(name: CustomFontType.bold.name, size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
        return view
    }()
    
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
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0))
        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0).cgColor
        contentView.layer.borderWidth = 1
        
    }
    
    func configureUI() {
        self.contentView.backgroundColor = UIColor(named: "viewBackgroundColor")
        
        self.contentView.addSubview(antImageView)
        self.contentView.addSubview(badgeTitleLabel)
        
    }
    
    func constraintLayout() {
        antImageView.snp.makeConstraints { make in
            make.height.equalTo(46)
            make.width.equalTo(74)
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
        }
        
        badgeTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(antImageView.snp.trailing).offset(20)
            make.trailing.bottom.equalToSuperview().inset(16)
            
        }
    }
}
