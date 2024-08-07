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
    let date: Date
    let success: Bool
}

struct study {
    let date: Date
    let success: Bool
}

enum status{
    case perfect
    case study
    case wakeup
}

class CalendarViewController: BaseViewController {
    
    // MARK: - properties
    
    private let dateFormatter: DateFormatter = {
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
    private var stateForData = 1
    private var result: [status] = []
    private var currentPageYearAndMonth: String = ""
    private var monthlyResultDict: [[Date: status]] = []
    private var tableHeight = 300 {
        didSet {
            badgeView.snp.removeConstraints()
            badgeView.snp.makeConstraints { make in
                make.top.equalTo(calendarbackView.snp.bottom).offset(15)
                make.leading.trailing.equalToSuperview()
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
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.bounces = false
    }
    
    private let scrollContentView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    //    private let advView: UIView = {
    //        let view = UIView()
    //        view.backgroundColor = .systemGray6
    //        return view
    //    }()
    
    private let calendarbackView = UIView().then {
        $0.backgroundColor = UIColor(named: "viewBackgroundColor2")
        $0.layer.cornerRadius = 16
        $0.layer.borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0).cgColor
        $0.layer.borderWidth = 0
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.15
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        $0.layer.shadowRadius = 5
        $0.clipsToBounds = false
    }
    
    private lazy var calendarView = FSCalendar().then {
        $0.dataSource = self
        $0.delegate = self
        
        //셀등록
        $0.register(CalendarCell.self, forCellReuseIdentifier: "CalendarCell")
        
        // 첫 열을 월요일로 설정
        $0.firstWeekday = 2
        $0.scope = .month
        
        $0.scrollDirection = .horizontal
        $0.locale = Locale(identifier: "ko_KR")
        
        // 현재 달의 날짜들만 표기하도록 설정
        $0.placeholderType = .none
        
        // 양옆 년도, 월 지우기
        $0.appearance.headerMinimumDissolvedAlpha = 0.0
        
        // 헤더뷰 설정
        $0.headerHeight = 50
        $0.appearance.headerDateFormat = "MM월"
        $0.appearance.headerTitleColor = .black
        $0.appearance.headerTitleAlignment = .left
        $0.appearance.headerMinimumDissolvedAlpha = 0.0
        
        // 요일 UI 설정
        $0.weekdayHeight = 16
        $0.appearance.weekdayFont = UIFont(name: CustomFontType.regular.name, size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.appearance.weekdayTextColor = .fontGray
        
        // 날짜 UI 설정
        $0.appearance.titleTodayColor = .black
        $0.appearance.titleFont = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
        
        //날짜 선택시
        $0.today = nil
        $0.appearance.selectionColor = .clear // 사용자가 선택한 날짜
        $0.appearance.titleSelectionColor = .fontBlack // 선택한 날짜 글자색
        $0.allowsSelection = false
        
    }
    
    private lazy var badgeView = UITableView().then {
        $0.backgroundColor = UIColor(named: "viewBackgroundColor")
        $0.dataSource = self
        $0.delegate = self
        $0.register(BadgeViewCell.self, forCellReuseIdentifier: "BadgeViewCell")
        $0.separatorStyle = .none
        $0.bounces = false
    }
    
    
    private let headerDateFormatter = DateFormatter().then {
        $0.dateFormat = "YYYY년 MM월"
        $0.locale = Locale(identifier: "ko_kr")
        $0.timeZone = TimeZone(identifier: "KST")
    }
    
    private lazy var customHeaderView = UIView().then {
        $0.backgroundColor = UIColor(named: "viewBackgroundColor2")
    }
    
    private let antImageView = UIImageView().then {
        $0.image = UIImage(named: "kingAnt")
        $0.contentMode = .scaleAspectFit
    }
    
    private let monthLabel = UILabel().then {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy년 MM월"
        
        let currentDate = Date()
        $0.text = dateFormatter.string(from: currentDate)
        
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let totalLabel = UILabel().then {
        let calendar = Calendar.current
        let currentDate = Date()
        guard let range = calendar.range(of: .day, in: .month, for: currentDate) else { return  }
        let numberOfDays = range.count
        $0.text = "/\(numberOfDays)"
        $0.textAlignment = .right
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let noAntLabel = UILabel().then {
        $0.font = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textColor = UIColor(named: "fontGray")
        $0.text = "이달의 개미가 없습니다."
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.constraintLayout()
        calCurrentYearAndMonth()
        

        if result.count == 0 {
           discardNoAntAlert()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setData()
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
        self.scrollContentView.addSubview(noAntLabel)
        self.scrollContentView.addSubview(badgeView)
        self.calendarView.addSubview(customHeaderView)
        self.customHeaderView.addSubview(monthLabel)
        self.customHeaderView.addSubview(totalLabel)
        self.customHeaderView.addSubview(antImageView)
        
    }
    
    override func constraintLayout() {
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(22)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(80)
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
            make.height.equalTo(410)
        }
        
        calendarView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        noAntLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(calendarbackView.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.height.equalTo(100)
        }
        
        badgeView.snp.makeConstraints { make in
            make.top.equalTo(noAntLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
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
            make.leading.equalToSuperview().offset(15)
        }
        
        totalLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(15)
            make.width.equalTo(40)
        }
        
        antImageView.snp.makeConstraints { make in
            make.trailing.equalTo(totalLabel.snp.leading)
            make.centerY.equalTo(totalLabel)
            make.height.equalTo(20)
            make.width.equalTo(30)
        }
    }
    
    private func checkUserAlertStatus(){
        
        var isNew = false
        
        //먼저 alert 조회해서 userAlert있는지 확읺
        firestoreManager.readAlertData { result in
            switch result {
            case .success(let data):
                let today = Date()
                let calendar = Calendar.current
                
                // 오늘의 날짜와 일치하는 data의 date 속성을 가진 항목만 필터링
                let todayDataCount = data.filter { study in
                    let studyTimestamp = study.date
                    let studyDate = studyTimestamp.dateValue() // Timestamp를 Date로 변환
                    return calendar.isDate(studyDate, inSameDayAs: today)
                }.count
                
                if todayDataCount == 0 { //없으면 빈거 생성
                    isNew = true
                    if isNew {
                        self.firestoreManager.createAlertData(state: 0)
                        self.stateForData = 0
                    }
                } else { //있으면
                    self.stateForData = data[0].state
                }
            case .failure(let error):
                print("Study 데이터 불러오기 에러: \(error)")
            }
            let isPerfect = self.statusForToday()
            
            //db 상태 0-완벽개미상태가 아님 1-완벽개미 상태임
            if isPerfect == .perfect && self.stateForData == 0{
                self.showPerfectAlert()
                self.firestoreManager.updateAlertData(state: 1)
            }
        }
        
    }
    
    private func statusForToday() -> status? {
        let today = Calendar.current.startOfDay(for: Date())
        
        for dict in monthlyResultDict {
            if let status = dict[today] {
                return status
            }
        }
        
        return nil
    }
    
    func showPerfectAlert() {
        let customAlert = AlertView(logImage: UIImage(named: "kingAnt")!,
                                    titleText: "완벽개미 획득!",
                                    doneButtonTitle: "확인")
        self.present(customAlert, animated: true)
    }
    
    private func updateCustomHeaderView(_ month: Date, _ days: Int){
        monthLabel.text = headerDateFormatter.string(from: month)
        totalLabel.text = "\(perfectAntTotalCount)/\(days)"
    }
    
    //사용자 기반으로 data 불러오기
    private func setData() {
        
        var studiesData = [study]()
        var wakeupsData = [wakeup]()
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        firestoreManager.readStudyData { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let datas):
                for data in datas{
                    let study = study(
                        date: self.removeTime(from: data.date.dateValue(), state: .study),
                        success: data.success
                    )
                    studiesData.append(study)
                }
            case .failure(let error):
                print("Study 데이터 불러오기 에러: \(error)")
            }
        }
        
        dispatchGroup.enter()
        firestoreManager.readWakeUpData { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let datas):
                for data in datas{
                    let wakeup = wakeup(
                        date: self.removeTime(from: data.date.dateValue(), state: .wakeup),
                        success: data.success
                    )
                    wakeupsData.append(wakeup)
                }
            case .failure(let error):
                print("WakeUp 데이터 불러오기 에러: \(error)")
            }
        }
        
        
        dispatchGroup.notify(queue: .main) {
            self.studies = studiesData
            self.wakeups = wakeupsData
            self.updateData()
            self.checkUserAlertStatus()
            self.calendarView.reloadData()
            self.badgeView.reloadData()
        }
    }
    
    private func updateData(){
        result = []
        monthlyResultDict = []
        monthlyResultDict = calculateThisMonthAnt(yearAndMonth: currentPageYearAndMonth)
        calculateStraightForBadge(of: .perfect)
        calculateStraightForBadge(of: .study)
        calculateStraightForBadge(of: .wakeup)
        
        //discardNoAntAlert()
        
    }
    
    private func removeTime(from date: Date, state: status) -> Date{
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        
        //5시 이전이면 전날로 설정
        if state == .study {
            let hour = calendar.component(.hour, from: date)
            
            if hour < 5 {
                guard let previousDay = calendar.date(byAdding: .day, value: -1, to: date) else {
                    return calendar.date(from: components)!
                }
                components = calendar.dateComponents([.year, .month, .day], from: previousDay)
            }
            return calendar.date(from: components)!
        } else {
            return calendar.date(from: components)!
        }
        
        
    }
    
    //총 공부개미 누적일 계산
    private func calculateStudyAntCount(){
        //먼저 유저의 studyData 조회
        //count
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
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
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
    private func calculateStraightForBadge(of type: status) {
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
    
    //timestamp를 date형식으로 변환
    private func convertTimestampToDate(timestamp: Timestamp) -> Date {
        return timestamp.dateValue()
    }
    
    //오늘 달과 날짜 계산
    private func calCurrentYearAndMonth(){
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yy.MM"
        
        let currentDate = Date()
        currentPageYearAndMonth = dateFormatter.string(from: currentDate)
    }
    
    //이달의 개미가 없을시에 라벨 추가
    private func showNoAntAlert(){
        
        noAntLabel.snp.removeConstraints()
        noAntLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(calendarbackView.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.height.equalTo(100)
        }
        

    }
    
    //이달의 개미가 없을시에 라벨 삭제
    private func discardNoAntAlert(){
        noAntLabel.snp.removeConstraints()
        noAntLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(calendarbackView.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.height.equalTo(0)
        }
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
        //        let customAlert = AlertView(logImage: UIImage(named: "kingAnt")!,
        //                                    titleText: "완벽개미 획득!",
        //                                    doneButtonTitle: "확인")
        //        self.present(customAlert, animated: true)
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
    
    //
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let today = Date()
        let calendar = Calendar.current
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        
        if todayComponents.year == dateComponents.year &&
            todayComponents.month == dateComponents.month &&
            todayComponents.day == dateComponents.day {
            return .pointOrange
        } else {
            return .fontGray
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
        if result.count == 0 {
            showNoAntAlert()
        } else {
            discardNoAntAlert()
        }
        calendarView.reloadData()
        self.scrollContentView.reloadInputViews()
        tableHeight = Int(CGFloat(result.count) * 100.0)
        badgeView.reloadData()
    }
}
