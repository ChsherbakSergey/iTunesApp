//
//  LibraryViewController.swift
//  iTunesApp
//
//  Created by Sergey on 12/11/20.
//

import UIKit
import SDWebImage

class LibraryViewController: UIViewController {

    //MARK: - Views that will be displayed on this controller
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(LibraryTableViewCell.self, forCellReuseIdentifier: LibraryTableViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    //MARK: - Constants and Variables
    var savedTracks : [Track] = []
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialUI()
        setDelegates()
        getDataFromUserDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setInitialUI()
        getDataFromUserDefaults()
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
        print(savedTracks.count)
    }
    
    ///Sets Delegates
    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func getDataFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: "SavedTracks") {
            do {
                //Create JSON Decoder
                let decoder = JSONDecoder()
                //Decode Data
                let tracks = try decoder.decode([Track].self, from: data)
                savedTracks = tracks
            } catch {
                print("Unable to decode, error: \(error)")
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}


extension LibraryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LibraryTableViewCell.identifier, for: indexPath) as! LibraryTableViewCell
        cell.configureCell(with: savedTracks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
