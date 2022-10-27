//
//  ContentView.swift
//  InstagramStoriesReplication
//
//  Created by Lev Litvak on 27.10.2022.
//

import SwiftUI
import AVKit
import Foundation

struct ContentView: View {
    @State private var activeVideo: Int = 0
    @State private var players = [AVPlayer]()
    @State private var showStories = false
    @State private var progress = [(current: Double, total: Double)]()
    @State private var playerView = PlayerView()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let urls = [
        URL(string: "https://assets.mixkit.co/videos/preview/mixkit-man-under-multicolored-lights-1237-large.mp4")!,
        URL(string: "https://assets.mixkit.co/videos/preview/mixkit-portrait-of-a-fashion-woman-with-silver-makeup-39875-large.mp4")!,
        URL(string: "https://assets.mixkit.co/videos/preview/mixkit-hands-holding-a-smart-watch-with-the-stopwatch-running-32808-large.mp4")!,
        URL(string: "https://assets.mixkit.co/videos/preview/mixkit-decorated-christmas-tree-in-close-up-shot-39750-large.mp4")!
    ]
    
    var body: some View {
        Button {
            showStories = true
        } label: {
            Text("Show \(players.count) stories")
        }
        .fullScreenCover(isPresented: $showStories) {
            stories
        }
        .onAppear {
            urls.enumerated().forEach { index, url in
                DispatchQueue.main.async {
                    let player = AVPlayer(url: urls[index])
                    progress.append((0, 5))
                    players.append(player)
                }
            }
        }
    }
    
    private var stories: some View {
        ZStack(alignment: .top) {
            playerView
                .onAppear {
                    playerView.player = players[activeVideo]
                    players[activeVideo].play()
                }
                .ignoresSafeArea()
            
            HStack {
                Color.primary.opacity(0.01)
                    .onTapGesture {
                        switchVideo(to: activeVideo - 1)
                    }
                Color.primary.opacity(0.01)
                    .onTapGesture {
                        switchVideo(to: activeVideo + 1)
                    }
            }
                    
            progressBars
        }
    }
    
    func switchVideo(to newActiveVideo: Int) {
        DispatchQueue.main.async { [activeVideo] in
            players[activeVideo].seek(to: .zero)
            players[activeVideo].pause()
        }
        
        if newActiveVideo == urls.count {
            activeVideo = 0
            showStories = false
        } else if newActiveVideo < 0 {
            activeVideo = 0
        } else {
            activeVideo = newActiveVideo
        }
        
        playerView.player = players[activeVideo]
        players[activeVideo].play()
    }
    
    private var progressBars: some View {
        HStack {
            ForEach(urls.indices, id: \.self) { index in
                ProgressView(
                    value: currentStatus(for: index),
                    total: progress[index].total)
                    .onReceive(timer) { _ in
                        progress[index].current = players[index].currentItem!.currentTime().seconds
                        progress[index].total = players[index].currentItem!.duration.seconds
                    }
                    .tint(.white)
            }
        }
    }
    
    func currentStatus(for index: Int) -> Double {
        if activeVideo > index {
            return progress[index].total
        } else if activeVideo < index {
            return 0
        } else {
            return progress[index].current
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
