//
//  LibraryViewController.swift
//  iTunesApp
//
//  Created by Sergey on 12/11/20.
//

import UIKit
import SDWebImage

final class LibraryViewController: UIViewController {

    //MARK: - Views that will be displayed on this controller
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(LibraryTableViewCell.self, forCellReuseIdentifier: LibraryTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.isHidden = true
        return tableView
    }()
    
    private let noTracksLabel : UILabel = {
        let label = UILabel()
        label.text = "No Added Tracks Yet..."
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 1
        label.textColor = .label
        label.textAlignment = .center
        label.isHidden = true
        return label
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
        checkTheNumberOfSongsInSavedArray()
    }
    
    //Setting frames of the views
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //Frame of the tableView
        tableView.frame = view.bounds
        //Frames of the NoTracks Label
        noTracksLabel.frame = CGRect(x: 20, y: view.height / 2 - 20, width: view.width - 40, height: 30)
    }

    //MARK: - Functions
    
    ///Configures initial Ui
    private func setInitialUI() {
        //Background color of the main view
        view.backgroundColor = .systemBackground
        //Adding subviews
        view.addSubview(tableView)
        view.addSubview(noTracksLabel)
        print(savedTracks.count)
    }
    
    ///Sets Delegates
    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    ///Checks the quantity of the songs in the saved array and based on it shows the songs or "No songs are added" label
    private func checkTheNumberOfSongsInSavedArray() {
        if savedTracks.count == 0 {
            tableView.isHidden = true
            noTracksLabel.isHidden = false
        } else {
            tableView.isHidden = false
            noTracksLabel.isHidden = true
        }
    }
    
    ///Gets the Tracks objects from user defaults by decoding it from data firstly
    private func getDataFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: "SavedTracks") {
            do {
                //Create JSON Decoder
                let decoder = JSONDecoder()
                //Decode Data
                let tracks = try decoder.decode([Track].self, from: data)
                savedTracks = tracks
            } catch {
                print(ProjectError.decodeError(message: "Unable to decode, error: \(error)"))
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

//MARK: - UITableViewDelegate and UITableViewDataSource Implementation

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
        let model = savedTracks[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = PlayerViewController()
        vc.previewURL = model.previewUrl
        vc.track = model
        vc.tracks.append(model)
        vc.numberOfTrack = model.trackNumber
        print(model.trackNumber)
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //remove element from a specific index and then encode savedTracks array again, so when the user closes the app or goes to another page when they return back it would show 'em the array without the track they deleleted before
            savedTracks.remove(at: indexPath.row)
            do {
                //Json Encoder
                let encoder = JSONEncoder()
                //Encode Tracks
                let data = try encoder.encode(savedTracks)
                //Write data to UserDefaults
                UserDefaults.standard.setValue(data, forKey: "SavedTracks")
            } catch {
                print(ProjectError.encodeError(message: "Unable to encode, error: \(error)"))
            }
            //Then reload data
            DispatchQueue.main.async { [weak self] in
                tableView.reloadData()
                self?.checkTheNumberOfSongsInSavedArray()
            }
        }
    }
    
}
