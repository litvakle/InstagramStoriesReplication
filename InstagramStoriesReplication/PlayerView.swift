//
//  StoriesViewModel.swift
//  InstagramStoriesReplication
//
//  Created by Lev Litvak on 27.10.2022.
//

import SwiftUI
import AVKit

struct PlayerView: UIViewRepresentable {
    var player: AVPlayer?
    
    func makeUIView(context: Context) -> UIView {
        let view = PlayerUIView(frame: .zero)
        if let player = player {
            view.update(for: player)
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
        if let player = player {
            (uiView as! PlayerUIView).update(for: player)
        }
    }
}

class PlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(for player: AVPlayer) {
        playerLayer.removeFromSuperlayer()
        playerLayer.player = player
        layer.addSublayer(playerLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
