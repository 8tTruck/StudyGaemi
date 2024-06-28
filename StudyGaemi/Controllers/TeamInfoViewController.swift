//
//  TeamInfoViewController.swift
//  StudyGaemi
//
//  Created by 신지연 on 2024/06/28.
//

import UIKit

class TeamInfoViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let teamInfoView = TeamInfoView()

    override func loadView() {
        view = teamInfoView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    private func setData(){
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        navigationItem.title = "개발자 정보"
        teamInfoView.profileTableView.delegate = self
        teamInfoView.profileTableView.dataSource = self
    }
    
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TeamInfoCell", for: indexPath) as? TeamInfoCell else {return TeamInfoCell()}
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.nameLabel.text = "김준철"
            cell.profileView.image = UIImage.cheol
        case 1:
            cell.nameLabel.text = "강태영"
            cell.profileView.image = UIImage.young
        case 2:
            cell.nameLabel.text = "신승현"
            cell.profileView.image = UIImage.hyeon
        case 3:
            cell.nameLabel.text = "신지연"
            cell.profileView.image = UIImage.yeon
        case 4:
            cell.nameLabel.text = "이승섭"
            cell.profileView.image = UIImage.seoup
        default:
            cell.nameLabel.text = "#"
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
