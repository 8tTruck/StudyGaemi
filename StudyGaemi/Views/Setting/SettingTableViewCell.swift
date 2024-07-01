//
//  SettingTableViewCell.swift
//  StudyGaemi
//
//  Created by 강태영 on 6/28/24.
//

import UIKit
import SnapKit
import Then

class SettingTableViewCell: UITableViewCell {

    let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = UIColor(named: "fontGray") 
    }

    let titleLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Regular", size: 17)
        $0.textColor = UIColor(named: "fontBlack")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }
    }
}
