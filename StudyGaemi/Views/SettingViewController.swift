//
//  SettingViewController.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 5/29/24.
//

import SnapKit
import Then
import UIKit

class SettingViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let titleLabel = UILabel().then {
        $0.text = "개Me"
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
    
    private let tableView = UITableView().then {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        $0.separatorStyle = .none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.constraintLayout()
        self.setupTableView()
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
        
        view.addSubview(tableView)
    }
    
    override func constraintLayout() {
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(22)
        }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = "First Cell"
            cell.contentView.layer.cornerRadius = 10
            cell.contentView.layer.masksToBounds = true
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        } else {
            cell.textLabel?.text = "Cell \(indexPath.row + 1)"
            
            let button = UIButton(type: .system).then {
                $0.setTitle("> \(indexPath.row + 1)", for: .normal)
                $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                $0.tag = indexPath.row
            }
            
            cell.contentView.addSubview(button)
            button.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-15)
                make.centerY.equalToSuperview()
            }
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = UIView().then {
                $0.backgroundColor = .white
            }
            let headerLabel = UILabel().then {
                $0.text = "설정"
                $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
                $0.textColor = UIColor(named: "fontBlack")
            }
            headerView.addSubview(headerLabel)
            headerLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(22)
                make.centerY.equalToSuperview()
            }
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 21 : 13
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        let pageIndex = sender.tag
        let destinationViewController = UIViewController()
        destinationViewController.view.backgroundColor = .white
        destinationViewController.title = "Page \(pageIndex + 1)"
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
}
