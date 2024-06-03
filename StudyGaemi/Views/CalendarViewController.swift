//
//  CalendarViewController.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 5/29/24.
//

import SnapKit
import Then
import UIKit
import FSCalendar

class CalendarViewController: BaseViewController {
    
    // MARK: - properties
    fileprivate let datesWithCat = ["20240601","20240605"]
    private let titleLabel = UILabel().then {
        $0.text = "월간개미"
        $0.font = UIFont(name: CustomFontType.bold.name, size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = UIColor(named: "fontBlack")
    }
    
    private let imageView = UIImageView().then {
        $0.image = UIImage(named: "mainAnt")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var titleView = UIStackView(arrangedSubviews: [imageView, titleLabel]).then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    private let scrollContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let advView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private let calendarbackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 5
        view.clipsToBounds = false
        return view
    }()
    
    private lazy var calendarView: FSCalendar = {
        let calendar = FSCalendar()
        calendar.dataSource = self
        calendar.delegate = self
        
        // 첫 열을 월요일로 설정
        calendar.firstWeekday = 2
        calendar.scope = .month
        
        calendar.scrollEnabled = false
        calendar.locale = Locale(identifier: "ko_KR")
        
        // 현재 달의 날짜들만 표기하도록 설정
        calendar.placeholderType = .none
        
        // 양옆 년도, 월 지우기
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        
        // 헤더뷰 설정
        calendar.headerHeight = 50
        calendar.appearance.headerDateFormat = "MM월"
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.headerTitleAlignment = .center
        
        // 요일 UI 설정
        calendar.calendarWeekdayView.removeFromSuperview()
        calendar.appearance.weekdayFont = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
        calendar.appearance.weekdayTextColor = .black
        
        // 날짜 UI 설정
        calendar.appearance.titleTodayColor = .black
        calendar.appearance.titleFont = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
        calendar.appearance.subtitleFont = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
        calendar.appearance.subtitleTodayColor = .pointOrange
        calendar.appearance.todayColor = .white
        
        // 일요일 라벨의 textColor를 red로 설정
        calendar.calendarWeekdayView.weekdayLabels.last!.textColor = .red
        return calendar
    }()
    
    private lazy var badgeView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        view.register(BadgeViewCell.self, forCellReuseIdentifier: "BadgeViewCell")
        view.separatorStyle = .none
        return view
    }()
    
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.constraintLayout()
        // Do any additional setup after loading the view.
    }
    
    override func configureUI() {
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        self.navigationItem.titleView = titleView
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance().then {
                $0.configureWithOpaqueBackground()
                $0.backgroundColor = UIColor(named: "viewBackgroundColor") ?? .systemBackground
                $0.shadowColor = UIColor(named: "navigationBarLine")
            }
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(scrollContentView)
        self.scrollContentView.addSubview(advView)
        self.scrollContentView.addSubview(calendarbackView)
        self.calendarbackView.addSubview(calendarView)
        self.scrollContentView.addSubview(badgeView)
        
    }
    
    override func constraintLayout() {
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(22)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollContentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        advView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(107)
        }
        
        calendarbackView.snp.makeConstraints { make in
            make.top.equalTo(advView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(450)
        }
        
        calendarView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        badgeView.snp.makeConstraints { make in
            make.top.equalTo(calendarbackView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(300)
            make.bottom.equalToSuperview().offset(20)
        }
    }
    
    
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BadgeViewCell", for: indexPath) as? BadgeViewCell else {return UITableViewCell()}
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
    
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    // 공식 문서에서 레이아우울을 위해 아래의 코드 요구
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
            // Do other updates
        }
        self.view.layoutIfNeeded()
    }
    
    //오늘 cell에 subtitle 생성
//    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "ko_KR")
//        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        
//        switch dateFormatter.string(from: date) {
//        case dateFormatter.string(from: Date()):
//            return "오늘"
//            
//        default:
//            return nil
//            
//        }
    }
    
    // 일요일에 해당되는 모든 날짜의 색상 red로 변경
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let day = Calendar.current.component(.weekday, from: date) - 1
        
        if Calendar.current.shortWeekdaySymbols[day] == "일" {
            return .systemRed
        } else {
            return .label
        }
    }
    

