//
//  ViewController.swift
//  iTunesApp
//
//  Created by Sergey on 12/9/20.
//

import UIKit

class AlbumsSearchController: UIViewController {
    
    //MARK: - Views that will be displayed on this controller
    private var collectionView : UICollectionView?
    
    private let searchController : UISearchController = {
        let searchController = UISearchController()
        searchController.loadViewIfNeeded()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.definesPresentationContext = true
        return searchController
    }()
    
    private let noResultsLabel : UILabel = {
        let label = UILabel()
        label.text = "No Results"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 1
        label.textColor = .label
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let tryANewSearchLabel : UILabel = {
        let label = UILabel()
        label.text = "Try a new search"
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 1
        label.textColor = .systemGray
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    //MARK: - Constants and Variables
    var albums : [Album] = []
    var lastSearch = ""
//    var filteredAlbums : [Album] = []
//    var isFiltered = false

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setDelegates()
        setInitialUI()
        JSONHandler.shared.getAlbums(query: "eminem", completion: { [weak self] albums in
                let newAlbums = albums.sorted(by: {$0 < $1})
                self?.albums.append(contentsOf: newAlbums)
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        })
    }

    //Setting frames for the views
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //Frame of the collectionView
        collectionView?.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        //Frames of the NoResult and tryANewSearch Labels
        noResultsLabel.frame = CGRect(x: 20, y: view.height / 2 - 20, width: view.width - 40, height: 30)
        tryANewSearchLabel.frame = CGRect(x: 20, y: noResultsLabel.bottom, width: view.width - 40, height: 30)
    }
    
    //MARK: - Functions
    
    ///Configures initial view
    private func setInitialUI() {
        //Background color of the main view
        view.backgroundColor = .systemBackground
        //Adding subviews
        navigationItem.searchController = searchController
        guard let collectionView = collectionView else {
            return
        }
        view.addSubview(collectionView)
        view.addSubview(noResultsLabel)
        view.addSubview(tryANewSearchLabel)
    }
    
    ///Sets Delegates
    private func setDelegates() {
        collectionView?.delegate = self
        collectionView?.dataSource = self
        searchController.searchBar.delegate = self
    }
    
    ///Configures collectionView
    private func configureCollectionView() {
        //Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 12.5, left: 15, bottom: 10, right: 15)
        layout.itemSize = CGSize(width: (view.width - 50) / 2,
                                 height: (view.width - 50) / 3.5)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.backgroundColor = .systemBackground
        //Cell Registration
        collectionView?.register(AlbumsCollectionViewCell.self, forCellWithReuseIdentifier: AlbumsCollectionViewCell.identifier)
    }

}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource and UICollectionViewDelegateFlowLayout Implementation

extension AlbumsSearchController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = albums[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumsCollectionViewCell.identifier, for: indexPath) as! AlbumsCollectionViewCell
        cell.configureCell(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let model = albums[indexPath.row]
        //Creating vc and provide it with necessary infromation
        let vc = DetailAlbumViewController()
        vc.title = model.collectionName
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.albumPicture = model.artworkUrl100
        vc.collectionName = model.collectionName
        vc.genreAndYear = "\(model.primaryGenreName) • \(model.releaseDate)"
        vc.collectionId = model.collectionId
        vc.artistName = model.artistName
        vc.copyright = model.copyright
        vc.trackCount = model.trackCount
        vc.artistViewUrl = model.artistViewUrl
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.width/2 - 20, height: 230)
    }
    
}


//MARK: - UISearchBarDelegate Implementation

extension AlbumsSearchController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Firstly delete all the existing albums and then add and show albums that has been found or if the searchText doesn't exist then show noResults
        albums.removeAll()
        if searchBar.text != nil || searchBar.text == "" {
            guard let searchText = searchBar.text else {
                return
            }
            JSONHandler.shared.getAlbums(query: searchText, completion: { [weak self] requestedAlbums in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.albums = requestedAlbums.sorted(by: {$0.collectionName < $1.collectionName})
                DispatchQueue.main.async {
                    if strongSelf.albums == [] {
                        strongSelf.collectionView?.isHidden = true
                        strongSelf.noResultsLabel.isHidden = false
                        strongSelf.tryANewSearchLabel.isHidden = false
                    } else {
                        strongSelf.collectionView!.reloadData()
                        strongSelf.noResultsLabel.isHidden = true
                        strongSelf.tryANewSearchLabel.isHidden = true
                        strongSelf.collectionView?.isHidden = false
                    }
                }
            })
            searchBar.resignFirstResponder()
            lastSearch = searchText
        }
    }
    
    //If the user clicks the cancel button we must show them what was on the screen before they started to search
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        albums.removeAll()
        JSONHandler.shared.getAlbums(query: lastSearch, completion: { [weak self] requestedAlbums in
            guard let strrongSelf = self else {
                return
            }
            strrongSelf.albums = requestedAlbums.sorted(by: {$0.collectionName < $1.collectionName})
            DispatchQueue.main.async {
                strrongSelf.collectionView?.reloadData()
            }
        })
        searchBar.resignFirstResponder()
    }
    
}

