//
//  DetailAlbumViewController.swift
//  iTunesApp
//
//  Created by Sergey on 12/9/20.
//

import UIKit
import SDWebImage

class DetailAlbumViewController: UIViewController {

    //MARK: - Views that will be displayed on this view
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.register(AlbumInfoTableViewCell.self, forCellReuseIdentifier: AlbumInfoTableViewCell.identifier)
        tableView.register(ListOfSongsTableViewCell.self, forCellReuseIdentifier: ListOfSongsTableViewCell.identifier)
        tableView.register(TrackCopyrightTableViewCell.self, forCellReuseIdentifier: TrackCopyrightTableViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let headerView = TrackTableHeaderView()
    
    //MARK: - Constants and Variables
    var collectionId = 0
    var tracks : [Track] = []
    var albumPicture : String = ""
    var trackCount = 0
    var copyright = ""
    var collectionName = ""
    var trackName = ""
    var genreAndYear = ""
    var artistName = ""
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialUI()
        setDelegates()
        JSONHandler.shared.getAlbumTracks(collectionId: Int(collectionId), completion: { [weak self] tracks in
            let newTracks = tracks
            self?.tracks.append(contentsOf: newTracks)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
    }
    
    //Setting frames for the views
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //Frame of the tableView Header
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width / 1.4)
        //Frame of the tableView
        tableView.frame = view.bounds
    }
    
    
    //MARK: - Configure View
    
    ///Configures initial UI
    private func setInitialUI() {
        view.backgroundColor = .systemBackground
        //Adding subviews
        view.addSubview(tableView)
        view.addSubview(headerView)
        headerView.imageView.sd_setImage(with: URL(string: albumPicture), completed: nil)
        tableView.tableHeaderView = headerView
    }
    
    ///Sets Delegates
    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}


//MARK: - UITableViewDelegate and UITableViewDataSource Implementation

extension DetailAlbumViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = tracks
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AlbumInfoTableViewCell.identifier, for: indexPath) as! AlbumInfoTableViewCell
            cell.delegate = self
            cell.configureCell(collectionName: collectionName, artistName: artistName, genreAndYear: genreAndYear)
            return cell
        }
        else if indexPath.row < tracks.count + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ListOfSongsTableViewCell.identifier, for: indexPath) as! ListOfSongsTableViewCell
            cell.configureCell(with: model[indexPath.row - 1], numberOfSong: indexPath.row)
            return cell
        }
        else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: TrackCopyrightTableViewCell.identifier, for: indexPath) as! TrackCopyrightTableViewCell
            cell.configureCell(with: copyright, numberOfTracks: trackCount)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = tracks
        let position = indexPath.row - 1
        //Presenting VC
        if indexPath.row == 0 {
            return
        } else if indexPath.row == tracks.count + 1 {
            return
        } else {
            let vc = PlayerViewController()
            vc.previewURL = model[position].previewUrl
            vc.track = model[position]
            vc.tracks = model
            vc.numberOfTrack = model[position].trackNumber
            print(model[position].trackNumber)
            present(vc, animated: true, completion: nil)
            
        }


    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 175
        } else {
            return 50
        }
    }
    
}

//MARK: - AlbumInfoTableViewCellDelegate Implementation

extension DetailAlbumViewController: AlbumInfoTableViewCellDelegate {
    
    func didTapPlayMusicButton() {
        let vc = PlayerViewController()
        vc.previewURL = tracks[0].previewUrl
        vc.track = tracks[0]
        vc.tracks = tracks
        vc.numberOfTrack = tracks[0].trackNumber
        present(vc, animated: true, completion: nil)
    }
    
}
