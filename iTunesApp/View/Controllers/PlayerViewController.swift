//
//  PlayerViewController.swift
//  iTunesApp
//
//  Created by Sergey on 12/10/20.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    //MARK: - Views that will be displayed on this controller
    private let coverImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let albumNameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let artistNameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .systemPink
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let slider : UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    private let volumeZero : UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.tintColor = .label
        imageView.image = UIImage(systemName: "speaker.wave.1.fill")
        return imageView
    }()

    private let volumeOneHundred : UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.tintColor = .label
        imageView.image = UIImage(systemName: "speaker.wave.3.fill")
        return imageView
    }()
    
    private let playAndPauseButton : UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .thin)
        let image = UIImage(systemName: "pause.fill", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let nextButton : UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .thin)
        let image = UIImage(systemName: "forward.fill", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let previousButton : UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .thin)
        let image = UIImage(systemName: "backward.fill", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialUI()
        setTergetsToButtons()
        loadTrack(trackUrl: previewURL)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
    }
    
    //Setting frames for the views
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //Frame of the coverImageView
        coverImageView.frame = CGRect(x: 50, y: 20, width: view.width - 100, height: view.width - 100)
        coverImageView.layer.cornerRadius = 5
        //Frame of the albumNameLabel
        albumNameLabel.frame = CGRect(x: 20, y: coverImageView.bottom + 15, width: view.width - 40, height: 20)
        //Frame of the artistNameLabel
        artistNameLabel.frame = CGRect(x: 20, y: albumNameLabel.bottom + 10, width: view.width - 40, height: 20)
        //Frames of the previous, next and playAndPause buttons
        previousButton.frame = CGRect(x: 40, y: artistNameLabel.bottom + 50, width: 40, height: 52)
        playAndPauseButton.frame = CGRect(x: view.width / 2 - 20, y: artistNameLabel.bottom + 50, width: 40, height: 52)
        nextButton.frame = CGRect(x: view.width - 80, y: artistNameLabel.bottom + 50, width: 40, height: 52)
        //Frame of the slider
        slider.frame = CGRect(x: 60, y: previousButton.bottom + 70, width: view.width - 120, height: 52)
        //Frame of the volume buttons
        volumeZero.frame = CGRect(x: 40, y: previousButton.bottom + 89.5, width: 13, height: 13)
        volumeOneHundred.frame = CGRect(x: view.width - 50, y: previousButton.bottom + 89.5, width: 13, height: 13)
    }
    
    //MARK: - Constants and Variables
    var player: AVPlayer?
    var track: Track?
    var tracks: [Track] = []
    var previewURL = ""
    var isPaused = false
    var numberOfTrack = 0
    
    
    //MARK: - Functions
    
    ///Confugires initial UI
    private func setInitialUI() {
        //Background color of the main view
        view.backgroundColor = .systemBackground
        //Adding Subviews
        view.addSubview(coverImageView)
        view.addSubview(albumNameLabel)
        view.addSubview(artistNameLabel)
        view.addSubview(playAndPauseButton)
        view.addSubview(previousButton)
        view.addSubview(nextButton)
        view.addSubview(slider)
        view.addSubview(volumeZero)
        view.addSubview(volumeOneHundred)
        //Set initial UI
        if numberOfTrack > 0 {
            albumNameLabel.text = tracks[numberOfTrack - 1].trackName
            artistNameLabel.text = tracks[numberOfTrack - 1].artistName
            coverImageView.sd_setImage(with: URL(string: tracks[numberOfTrack - 1].artworkUrl100), completed: nil)
        }
    }
    
    ///Plays audio using provided url
    private func loadTrack(trackUrl: String) {
        guard let url = URL.init(string: trackUrl) else {
            return
        }
        let playerItem = AVPlayerItem.init(url: url)
        player = AVPlayer.init(playerItem: playerItem)
        player?.volume = 0.5
        player?.play()
    }
    
    ///Sets targets to buttons
    private func setTergetsToButtons() {
        slider.addTarget(self, action: #selector(didChangeValueOfTheSlider(_:)), for: .valueChanged)
        previousButton.addTarget(self, action: #selector(didTapPreviousButton), for: .touchUpInside)
        playAndPauseButton.addTarget(self, action: #selector(didTapPlayAndPauseButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
    }
    
    ///Changes the volume of the player using slider value
    @objc private func didChangeValueOfTheSlider(_ slider: UISlider) {
        let value = slider.value
        //adjust volume of the player
        player?.volume = value
    }
    
    ///Plays previous track
    @objc private func didTapPreviousButton() {
        if numberOfTrack == 0 {
            player?.pause()
            for subview in view.subviews {
                subview.removeFromSuperview()
            }
            setInitialUI()
            loadTrack(trackUrl: tracks[numberOfTrack].previewUrl)
            player?.play()
            setPlayAndPauseButtonWhenHitBackwardOrForward()
        }
        if numberOfTrack == tracks.count {
            player?.pause()
            for subview in view.subviews {
                subview.removeFromSuperview()
            }
            setInitialUI()
            loadTrack(trackUrl: tracks[numberOfTrack - 1].previewUrl)
            player?.play()
            setPlayAndPauseButtonWhenHitBackwardOrForward()
        }
        if numberOfTrack == 1 {
            player?.pause()
            for subview in view.subviews {
                subview.removeFromSuperview()
            }
            setInitialUI()
            loadTrack(trackUrl: tracks[numberOfTrack - 1].previewUrl)
            player?.play()
            numberOfTrack -= 1
            setPlayAndPauseButtonWhenHitBackwardOrForward()
        }
        if numberOfTrack > 0 {
            numberOfTrack -= 1
            player?.pause()
            for subview in view.subviews {
                subview.removeFromSuperview()
            }
            setInitialUI()
            loadTrack(trackUrl: tracks[numberOfTrack - 1].previewUrl)
            player?.play()
            setPlayAndPauseButtonWhenHitBackwardOrForward()
        }
    }
    
    ///Stops or resumes the audio and also sets the button image deponding on its state
    @objc private func didTapPlayAndPauseButton() {
        //If the audio is playing then pause it otherwise start playing it
        if isPaused == false {
            player?.pause()
            isPaused = true
            let configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .thin)
            let image = UIImage(systemName: "play.fill", withConfiguration: configuration)
            playAndPauseButton.setImage(image, for: .normal)
            //shrink cover image
        } else {
            player?.play()
            isPaused = false
            setPlayAndPauseButtonWhenHitBackwardOrForward()
            //increase image size
        }
    }
    
    ///Plays next track
    @objc private func didTapNextButton() {
        if numberOfTrack == 0 {
            numberOfTrack += 1
            player?.pause()
            for subview in view.subviews {
                subview.removeFromSuperview()
            }
            setInitialUI()
            loadTrack(trackUrl: tracks[numberOfTrack].previewUrl)
            player?.play()
            setPlayAndPauseButtonWhenHitBackwardOrForward()
        }
        if numberOfTrack == tracks.count {
            player?.pause()
            for subview in view.subviews {
                subview.removeFromSuperview()
            }
            setInitialUI()
            loadTrack(trackUrl: tracks[numberOfTrack - 1].previewUrl)
            player?.play()
            setPlayAndPauseButtonWhenHitBackwardOrForward()
        }
        if numberOfTrack < tracks.count {
            numberOfTrack += 1
            player?.pause()
            for subview in view.subviews {
                subview.removeFromSuperview()
            }
            setInitialUI()
            loadTrack(trackUrl: tracks[numberOfTrack - 1].previewUrl)
            player?.play()
            setPlayAndPauseButtonWhenHitBackwardOrForward()
        }
    }
    
    ///Sets a pause image to the button
    func setPlayAndPauseButtonWhenHitBackwardOrForward() {
        //If the audio is paused and user tap backward or forward, music starts to play so the button should have a pause image instead of play
        let configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .thin)
        let image = UIImage(systemName: "pause.fill", withConfiguration: configuration)
        playAndPauseButton.setImage(image, for: .normal)
    }

}
