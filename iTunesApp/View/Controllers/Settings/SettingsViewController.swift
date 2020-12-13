//
//  SettingsViewController.swift
//  iTunesApp
//
//  Created by Sergey on 12/12/20.
//

import UIKit

final class SettingsViewController: UIViewController {

    //MARK: - Views that will be displayed on this controller
    
    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        return tableView
    }()
    
    //MARK: - Constants and Variables
    var models = [Section]()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialUI()
        setDelegates()
        createSettingsModels()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //Frame of the tableView
        tableView.frame = view.bounds
    }
    
    //MARK: - Functions
    
    ///Configures Initial UI
    private func setInitialUI() {
        //Background color of the main view
        view.backgroundColor = .systemBackground
        //Adding subviews
        view.addSubview(tableView)
    }
    
    ///Sets delegates
    private func setDelegates(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    ///Congigures settings models
    private func createSettingsModels() {
        models.append(Section(title: "General", options: [
            Settings(title: "Profile", iconImage: UIImage(systemName: "person.circle"), iconBackgroundColor: .systemPink, handler: {
                
            }),
            Settings(title: "Data", iconImage: UIImage(systemName: "info.circle"), iconBackgroundColor: .systemBlue, handler: {
                
            })
        ]))
        models.append(Section(title: "Notifications", options: [
            Settings(title: "Notifications", iconImage: UIImage(systemName: "bell.circle"), iconBackgroundColor: .systemGreen, handler: {
                
            })
        ]))
        models.append(Section(title: "Finance", options: [
            Settings(title: "Redeem Gift Card or Code", iconImage: UIImage(systemName: "giftcard"), iconBackgroundColor: .systemPink, handler: {
                
            }),
            Settings(title: "Add Funds to Apple ID", iconImage: UIImage(systemName: "bitcoinsign.circle"), iconBackgroundColor: .systemBlue, handler: {
                
            }),
            Settings(title: "Manage Subscriptions", iconImage: UIImage(systemName: "pencil.circle"), iconBackgroundColor: .systemPink, handler: {
                
            }),
            Settings(title: "Upgrade to Family Plan", iconImage: UIImage(systemName: "person.2.circle"), iconBackgroundColor: .systemBlue, handler: {
                
            })
        ]))
    }
    
    
}

//MARK: - UITableViewDelegate and UITableViewDataSource Implementation

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return models[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
        cell.configureCell(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 0 {
            let vc = ProfileViewController()
            vc.title = "Profile"
            vc.navigationItem.largeTitleDisplayMode = .always
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
