//
//  LibraryViewController.swift
//  iTunesApp
//
//  Created by Sergey on 12/11/20.
//

import UIKit

class LibraryViewController: UIViewController {

    //MARK: - Views that will be displayed on this controller
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(LibraryTableViewCell.self, forCellReuseIdentifier: LibraryTableViewCell.identifier)
        return tableView
    }()
    
    //MARK: - Constants and Variables
    var savedTracks : [SavedTrack] = []
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialUI()
        setDelegates()
    }
    
    //Setting frames of the views
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //Frame of the tableView
        tableView.frame = view.bounds
    }

    //MARK: - Functions
    
    ///Configures initial Ui
    private func setInitialUI() {
        //Background color of the main view
        view.backgroundColor = .systemBackground
        //Adding subviews
        view.addSubview(tableView)
    }
    
    ///Sets Delegates
    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}


extension LibraryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LibraryTableViewCell.identifier, for: indexPath) as! LibraryTableViewCell
        cell.configureCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
