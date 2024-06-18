//
//  CalendarCell.swift
//  StudyGaemi
//
//  Created by 신지연 on 2024/06/04.
//

import UIKit
import SnapKit
import FSCalendar

class CalendarCell: FSCalendarCell {
    
    // MARK: - properties
    // 뱃지이미지
    var badgeView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLabel.textColor = .fontBlack
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(5)
        }
        
        contentView.insertSubview(badgeView, at: 0)
        badgeView.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(contentView).inset(3)
            make.size.equalTo(minSize())
        }
        badgeView.layer.cornerRadius = minSize()/2
    }
    
    required init(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        badgeView.image = nil
    }
    
    // 셀의 높이와 너비 중 작은 값 리턴
    func minSize() -> CGFloat {
        let width = contentView.bounds.width - 20
        let height = contentView.bounds.height - 20

        return (width > height) ? height : width
    }
}
