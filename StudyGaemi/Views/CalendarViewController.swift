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
import Foundation
import FirebaseFirestore
import FirebaseAuth

struct wakeup {
    let email: String
    let date: Date
    let success: Bool
}

struct study {
    let email: String
    let date: Date
    let success: Bool
}

enum badgeStatus{
    case perfect
    case study
    case wakeup
}

enum status{
    case perfect
    case study
    case wakeup
}

class CalendarViewController: BaseViewController {
    
    // MARK: - properties
    // 예시 리스트
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    private let firestoreManager = FirestoreManager.shared
    
    //특정달의 정보만
    var studies: [study] = []
    var wakeups: [wakeup] = []
    
    private var perfectAntCount = 0
    private var studyAntCount = 0
    private var wakeupAntCount = 0
    private var result: [badgeStatus] = []
    private var currentPageYearAndMonth: String = ""
    private var monthlyResultDict: [[Date: status]] = []
    private var tableHeight = 300 {
        didSet {
            badgeView.snp.removeConstraints()
            badgeView.snp.makeConstraints { make in
                make.top.equalTo(calendarbackView.snp.bottom).offset(15)
                make.leading.trailing.equalToSuperview().inset(20)
                make.height.equalTo(tableHeight)
                make.bottom.equalToSuperview().inset(10)
            }
            badgeView.reloadData()
        }
    }
    private var perfectAntTotalCount = 0 {
        didSet {
            let currentPage = calendarView.currentPage
            let calendar = Calendar.current
            guard let range = calendar.range(of: .day, in: .month, for: currentPage) else { return }
            let numberOfDays = range.count
            updateCustomHeaderView(currentPage, numberOfDays)
        }
    }
    
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
        scrollView.bounces = false
        return scrollView
    }()
    
    private let scrollContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    //    private let advView: UIView = {
    //        let view = UIView()
    //        view.backgroundColor = .systemGray6
    //        return view
    //    }()
    
    private let calendarbackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        view.layer.cornerRadius = 16
        view.layer.borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0).cgColor
        view.layer.borderWidth = 1
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
        
        //셀등록
        calendar.register(CalendarCell.self, forCellReuseIdentifier: "CalendarCell")
        
        // 첫 열을 월요일로 설정
        calendar.firstWeekday = 2
        calendar.scope = .month
        
        calendar.scrollDirection = .horizontal
        calendar.locale = Locale(identifier: "ko_KR")
        
        // 현재 달의 날짜들만 표기하도록 설정
        calendar.placeholderType = .none
        
        // 양옆 년도, 월 지우기
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        
        // 헤더뷰 설정
        calendar.headerHeight = 45
        calendar.appearance.headerDateFormat = "MM월"
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.headerTitleAlignment = .left
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        
        // 요일 UI 설정
        calendar.weekdayHeight = 0
        
        // 날짜 UI 설정
        calendar.appearance.titleTodayColor = .black
        calendar.appearance.titleFont = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
        
        //날짜 선택시
        calendar.appearance.todayColor = .clear
        calendar.appearance.titleTodayColor = .pointOrange //Today에 표시되는 특정 글자색
        calendar.appearance.todaySelectionColor = .fontBlack //오늘날짜 선택시 색상
        calendar.appearance.selectionColor = .clear // 사용자가 선택한 날짜
        calendar.appearance.titleSelectionColor = .fontBlack // 선택한 날짜 글자색
        
        return calendar
    }()
    
    private lazy var badgeView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        view.dataSource = self
        view.delegate = self
        view.register(BadgeViewCell.self, forCellReuseIdentifier: "BadgeViewCell")
        view.separatorStyle = .none
        view.bounces = false
        return view
    }()
    
    
    let headerDateFormatter = DateFormatter().then {
        $0.dateFormat = "YYYY년 MM월"
        $0.locale = Locale(identifier: "ko_kr")
        $0.timeZone = TimeZone(identifier: "KST")
    }
    
    private lazy var customHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        return view
    }()
    
    let monthLabel: UILabel = {
        let label = UILabel()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy년 MM월"
        
        let currentDate = Date()
        label.text = dateFormatter.string(from: currentDate)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let totalLabel: UILabel = {
        let label = UILabel()
        let calendar = Calendar.current
        let currentDate = Date()
        guard let range = calendar.range(of: .day, in: .month, for: currentDate) else {
            label.text = "Error calculating days"
            return label
        }
        let numberOfDays = range.count
        label.text = "/\(numberOfDays)"
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.constraintLayout()
        calCurrentYearAndMonth()
        
        studies = [
            study(email: "user6@example.com", date: dateFormatter.date(from: "2024/05/05")!, success: true),
            study(email: "user7@example.com", date: dateFormatter.date(from: "2024/05/11")!, success: true),
            study(email: "user6@example.com", date: dateFormatter.date(from: "2024/06/01")!, success: true),
            study(email: "user7@example.com", date: dateFormatter.date(from: "2024/06/02")!, success: true),
            study(email: "user8@example.com", date: dateFormatter.date(from: "2024/06/03")!, success: true),
            study(email: "user9@example.com", date: dateFormatter.date(from: "2024/06/04")!, success: false),
            study(email: "user10@example.com", date: dateFormatter.date(from: "2024/06/05")!, success: false),
            study(email: "user6@example.com", date: dateFormatter.date(from: "2024/06/06")!, success: true),
            study(email: "user7@example.com", date: dateFormatter.date(from: "2024/06/07")!, success: true),
            study(email: "user8@example.com", date: dateFormatter.date(from: "2024/06/08")!, success: true),
            study(email: "user9@example.com", date: dateFormatter.date(from: "2024/06/09")!, success: false),
            study(email: "user9@example.com", date: dateFormatter.date(from: "2024/06/10")!, success: false)
        ]
        wakeups = [
            wakeup(email: "user6@example.com", date: dateFormatter.date(from: "2024/06/01")!, success: true),
            wakeup(email: "user7@example.com", date: dateFormatter.date(from: "2024/06/02")!, success: true),
            wakeup(email: "user8@example.com", date: dateFormatter.date(from: "2024/06/03")!, success: true),
            wakeup(email: "user9@example.com", date: dateFormatter.date(from: "2024/06/04")!, success: true),
            wakeup(email: "user10@example.com", date: dateFormatter.date(from: "2024/06/05")!, success: true),
            wakeup(email: "user6@example.com", date: dateFormatter.date(from: "2024/06/06")!, success: true),
            wakeup(email: "user7@example.com", date: dateFormatter.date(from: "2024/06/07")!, success: true),
            wakeup(email: "user8@example.com", date: dateFormatter.date(from: "2024/06/08")!, success: false),
            wakeup(email: "user9@example.com", date: dateFormatter.date(from: "2024/06/09")!, success: true),
            wakeup(email: "user10@example.com", date: dateFormatter.date(from: "2024/06/10")!, success: true)
            
        ]
        updateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setData()
    }
    
    //사용자 기반으로 data 불러오기
    private func setData() {
        firestoreManager.readStudyData { result in
            switch result {
            case .success(let data):
                print("Study 데이터 불러오기 완료")
            case .failure(let error):
                print("Study 데이터 불러오기 에러: \(error)")
            }
        }
        
        firestoreManager.readWakeUpData { result in
            switch result {
            case .success(let data):
                print("WakeUp 데이터 불러오기 완료")
            case .failure(let error):
                print("WakeUp 데이터 불러오기 에러: \(error)")
            }
        }
    }
    
    // MARK: - method
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
        //self.scrollContentView.addSubview(advView)
        self.scrollContentView.addSubview(calendarbackView)
        self.calendarbackView.addSubview(calendarView)
        self.scrollContentView.addSubview(badgeView)
        self.calendarView.addSubview(customHeaderView)
        self.customHeaderView.addSubview(monthLabel)
        self.customHeaderView.addSubview(totalLabel)
        
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
        
        //        advView.snp.makeConstraints { make in
        //            make.leading.trailing.top.equalToSuperview()
        //            make.height.equalTo(107)
        //        }
        
        calendarbackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(400)
        }
        
        calendarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        badgeView.snp.makeConstraints { make in
            make.top.equalTo(calendarbackView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(tableHeight)
            make.bottom.equalToSuperview().inset(10)
        }
        
        customHeaderView.snp.makeConstraints { make in
            make.centerY.equalTo(calendarView.calendarHeaderView.snp.centerY)
            make.leading.trailing.equalTo(calendarView.collectionView)
            make.height.equalTo(30)
        }
        
        monthLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
        }
        
        totalLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
            make.width.equalTo(50)
        }
    }
    
    
    private func updateCustomHeaderView(_ month: Date, _ days: Int){
        monthLabel.text = headerDateFormatter.string(from: month)
        totalLabel.text = "\(perfectAntTotalCount)/\(days)"
    }
    
    private func updateData(){
        result = []
        monthlyResultDict = []
        monthlyResultDict = calculateThisMonthAnt(yearAndMonth: currentPageYearAndMonth)
        calculateStraightForBadge(of: .perfect)
        calculateStraightForBadge(of: .study)
        calculateStraightForBadge(of: .wakeup)
    }
    
    //이달의 완벽개미, 공부개미, 기상개미 측정
    private func calculateThisMonthAnt(yearAndMonth: String) -> [[Date: status]] {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yy.MM"
        
        guard let yearMonthDate = dateFormatter.date(from: yearAndMonth) else {
            print("Invalid year and month format")
            return []
        }
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        
        let range = calendar.range(of: .day, in: .month, for: yearMonthDate)!
        var components = calendar.dateComponents([.year, .month], from: yearMonthDate)
        
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        for day in range {
            var resultDict: [Date: status] = [:]
            components.day = day
            guard let date = calendar.date(from: components) else { continue }
            
            let matchingStudies = studies.filter { $0.date == date }
            if !matchingStudies.isEmpty{
                let successfulStudy = matchingStudies.contains { $0.success }
                if successfulStudy {
                    resultDict[date] = .study
                }
            }
            
            let matchingWakeups = wakeups.filter { $0.date == date }
            if !matchingWakeups.isEmpty {
                let successfulWakeup = matchingWakeups.contains { $0.success }
                if successfulWakeup {
                    if let previousResult = resultDict[date], previousResult == .study {
                        resultDict[date] = .perfect
                    } else {
                        resultDict[date] = .wakeup
                    }
                }
            }
            if !resultDict.isEmpty {
                monthlyResultDict.append(resultDict)
            }
        }
        
        monthlyResultDict.sort { (dict1, dict2) in
            guard let date1 = dict1.keys.first, let date2 = dict2.keys.first else {
                return false // 빈 거 고려
            }
            return date1 < date2
        }
        
        return monthlyResultDict
    }
    
    //연속일 계산
    private func calculateStraightForBadge(of type: badgeStatus) {
        var max = 0
        var temp = 0
        var badgeCount = 0
        let badgeValues: Set<status>
        
        switch type {
        case .perfect:
            perfectAntTotalCount = 0 // 초기화
            badgeValues = [.perfect]
        case .study:
            badgeValues = [.study, .perfect]
        case .wakeup:
            badgeValues = [.wakeup, .perfect]
        }
        
        if let firstDict = monthlyResultDict.first, let firstDay = firstDict.keys.first {
            var yesterday = firstDay
            let calendar = Calendar.current
            
            for dic in monthlyResultDict {
                for (day, value) in dic {
                    if badgeValues.contains(value) {
                        let difference = calendar.dateComponents([.day], from: yesterday, to: day)
                        
                        if let dayDifference = difference.day, dayDifference == 1 {
                            temp += 1
                            max = temp >= max ? temp : max
                            badgeCount += 1
                            yesterday = day
                        } else {
                            temp = 1
                            max = temp >= max ? temp : max
                            badgeCount += 1
                            yesterday = day
                        }
                    } else {
                        temp = 0
                        yesterday = day
                    }
                }
            }
        }
        
        switch type {
        case .perfect:
            perfectAntCount = 0
            perfectAntTotalCount = badgeCount
            if max != 0 {
                result.append(.perfect)
                perfectAntCount = max
            }
        case .study:
            studyAntCount = 0
            if max != 0 {
                result.append(.study)
                studyAntCount = max
            }
        case .wakeup:
            wakeupAntCount = 0
            if max != 0 {
                result.append(.wakeup)
                wakeupAntCount = max
            }
        }
    }
    
    //오늘 달과 날짜 계산
    private func calCurrentYearAndMonth(){
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yy.MM"
        
        let currentDate = Date()
        currentPageYearAndMonth = dateFormatter.string(from: currentDate)
    }
    
}

// MARK: - extension
extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BadgeViewCell", for: indexPath) as? BadgeViewCell else {return UITableViewCell()}
        cell.selectionStyle = .none
        switch result[indexPath.row]{
        case .perfect :
            cell.bind(yearAndMonth: currentPageYearAndMonth, days: perfectAntCount, ant: "완벽개미 달성")
        case .study :
            cell.bind(yearAndMonth: currentPageYearAndMonth, days: studyAntCount, ant: "공부개미 달성")
        case .wakeup :
            cell.bind(yearAndMonth: currentPageYearAndMonth, days: wakeupAntCount, ant: "기상개미 달성")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customAlert = AlertView(logImage: UIImage(named: "kingAnt")!,
                                    titleText: "완벽개미 획득!",
                                    doneButtonTitle: "확인")
        self.present(customAlert, animated: true)
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
        }
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell{
        guard let cell = calendar.dequeueReusableCell(withIdentifier: "CalendarCell", for: date, at: position) as? CalendarCell else { return FSCalendarCell() }
        let calendar = Calendar.current
        
        for resultDict in monthlyResultDict {
            for (dat, status) in resultDict {
                if calendar.isDate(dat, inSameDayAs: date) {
                    switch status {
                    case .perfect:
                        cell.badgeView.image = UIImage.perfectStamp
                    case .study:
                        cell.badgeView.image = UIImage.studyStamp
                    case .wakeup:
                        cell.badgeView.image = UIImage.wakeupStamp
                    }
                }
            }
        }
        
        return cell
    }
    
    // 오늘 날짜 원 모양 변경 (사각형으로 바꾸기 가능)
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let today = Date()
        let calendar = Calendar.current
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        
        if todayComponents.year == dateComponents.year &&
            todayComponents.month == dateComponents.month &&
            todayComponents.day == dateComponents.day {
            return .systemBlue
        } else {
            return .fontBlack
        }
    }
    
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPage = calendarView.currentPage
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: currentPage) else { return }
        let numberOfDays = range.count
        updateCustomHeaderView(currentPage, numberOfDays)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM"
        currentPageYearAndMonth = formatter.string(from: currentPage)
        
        updateData()
        calendarView.reloadData()
        tableHeight = Int(CGFloat(result.count) * 100.0)
        badgeView.reloadData()
    }
}
