//
//  ViewController.swift
//  StreamingIos
//
//  Created by Kalandarov Vakil on 22.08.2022.
//

import UIKit
import AVKit

final class StreamingViewController: UIViewController {

    private lazy var player: UIView = {
        let playerView = playerVC.view!
        playerView.translatesAutoresizingMaskIntoConstraints = false
        return playerView
    }()
    
    private lazy var streamingView: UIView = {
        let streamView = UIView()
        streamView.translatesAutoresizingMaskIntoConstraints = false
        return streamView
    }()
    
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = videoModel[0].title
        return title
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var iconChannel: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        return iconImageView
    }()
    
    private lazy var numberChanellLabel: UILabel = {
        let numberLabel = UILabel()
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.textAlignment = .center
        numberLabel.text = String(swipePosition + 1)
        return numberLabel
    }()
    
    private var videoModel: [VideoPlayerModel] = {
        var channelOne = VideoPlayerModel()
        channelOne.title = "Первый канал HD"
        channelOne.channel_url = URL(string: "http://str09.ottg.tv/2214/video.m3u8?username=sf326&password=YFXV4RQI27&token=d92aefab3161657571e5045f5e728959&ch_id=76&req_host=pkjX3BL")
        channelOne.tvLogo = URL(string: "http://pl.ottg.tv:80/icon/2214.png")
        
        var channelTwo = VideoPlayerModel()
        channelTwo.title = "Россия 1"
        channelTwo.channel_url = URL(string: "http://str09.ottg.tv/9226/video.m3u8?username=sf326&password=YFXV4RQI27&token=d92aefab3161657571e5045f5e728959&ch_id=80&req_host=pkjX3BL")
        channelTwo.tvLogo = URL(string: "http://pl.ottg.tv:80/icon/9226.png")
        
        var channelThree = VideoPlayerModel()
        channelThree.title = "НТВ"
        channelThree.channel_url = URL(string: "http://str09.ottg.tv/9413/video.m3u8?username=sf326&password=YFXV4RQI27&token=d92aefab3161657571e5045f5e728959&ch_id=86&req_host=pkjX3BL")
        channelThree.tvLogo = URL(string: "http://pl.ottg.tv:80/icon/9413.png")
        
        var channelFour = VideoPlayerModel()
        channelFour.title = "Home 4K PREMIUM+"
        channelFour.channel_url = URL(string: "http://str09.ottg.tv/7533/video.m3u8?username=sf326&password=YFXV4RQI27&token=d92aefab3161657571e5045f5e728959&ch_id=450&req_host=pkjX3BL")
        channelFour.tvLogo = URL(string: "http://pl.ottg.tv:80/icon/7533.png")
        return[channelOne, channelTwo, channelThree, channelFour]
    }()
    
    private var swipePosition = 0
    private let avPlayer = AVPlayer()
    private let playerVC = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createSwipeMethod()
        createPlayer()
        getImage()
    }
    
    private func setupUI() {
        view.addSubview(contentStackView)
        view.addSubview(streamingView)
        streamingView.addSubview(player)
        contentStackView.addArrangedSubview(iconChannel)
        contentStackView.addArrangedSubview(numberChanellLabel)
        contentStackView.addArrangedSubview(titleLabel)
        NSLayoutConstraint.activate([
            streamingView.topAnchor.constraint(equalTo: contentStackView.bottomAnchor),
            streamingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            streamingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            streamingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            player.topAnchor.constraint(equalTo: streamingView.topAnchor),
            player.bottomAnchor.constraint(equalTo: streamingView.bottomAnchor),
            player.leftAnchor.constraint(equalTo: streamingView.leftAnchor),
            player.rightAnchor.constraint(equalTo: streamingView.rightAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentStackView.heightAnchor.constraint(equalToConstant: 50),
            iconChannel.widthAnchor.constraint(equalToConstant: 50),
            
        ])
    }
    
    private func createSwipeMethod() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
    }
    
    @objc private func swipeDown() {
        swipePosition -= 1
        if swipePosition < 0 {
            swipePosition = videoModel.count - 1
        }
        titleLabel.text = videoModel[swipePosition].title
        guard let channelURL = videoModel[swipePosition].channel_url else { return }
        let asset = AVAsset(url: (channelURL))
        let playerItem = AVPlayerItem(asset: asset)
        avPlayer.replaceCurrentItem(with: playerItem)
        
        guard let imageURL = videoModel[swipePosition].tvLogo else { return }
        guard let imageData = try? Data(contentsOf: imageURL) else { return }
        let image = UIImage(data: imageData)
        self.iconChannel.image = image
        
        numberChanellLabel.text = String(swipePosition + 1)
    }
    
    @objc private func swipeUp() {
        swipePosition += 1
        if swipePosition > videoModel.count - 1 {
            swipePosition = 0
        }
        titleLabel.text = videoModel[swipePosition].title
        guard let channelURL = videoModel[swipePosition].channel_url else { return }
        let asset = AVAsset(url: (channelURL))
        let playerItem = AVPlayerItem(asset: asset)
        avPlayer.replaceCurrentItem(with: playerItem)
        
        guard let imageURL = videoModel[swipePosition].tvLogo else { return }
        guard let imageData = try? Data(contentsOf: imageURL) else { return }
        let image = UIImage(data: imageData)
        self.iconChannel.image = image
        
        numberChanellLabel.text = String(swipePosition + 1)
    }
    
    private func getImage() {
        guard let imageURL = videoModel[0].tvLogo else { return }
        guard let imageData = try? Data(contentsOf: imageURL) else { return }
        let image = UIImage(data: imageData)
        self.iconChannel.image = image
    }
    
    private func createPlayer() {
        guard let channelURL = videoModel[0].channel_url else { return }
        let asset = AVAsset(url: (channelURL))
        let playerItem = AVPlayerItem(asset: asset)
        avPlayer.replaceCurrentItem(with: playerItem)
        playerVC.player = avPlayer
        playerVC.videoGravity = .resizeAspectFill
        playerVC.player?.play()
    }
}

