//
//  Player.swift
//  SwiftTalk
//
//  Created by Chris Eidhof on 04.07.19.
//  Copyright © 2019 Chris Eidhof. All rights reserved.
//

import SwiftUI
import AVKit

final class PlayerCoordinator<Overlay: View> {
    var observer: NSKeyValueObservation?
    var timeObserver: Any?
    var hostingViewController: UIHostingController<Overlay>?
    var lastObservedPosition = TimeInterval(0)
}

struct Player<Overlay: View>: UIViewControllerRepresentable {
    let url: URL
    @Binding var isPlaying: Bool
    @Binding var playPosition: TimeInterval
    let overlay: Overlay?
    
    func makeCoordinator() -> PlayerCoordinator<Overlay?> {
        return PlayerCoordinator()
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<Player>) -> AVPlayerViewController {
        let player = AVPlayer(url: url)
        
        context.coordinator.observer = player.observe(\.rate, options: [.new]) { _, change in
            self.isPlaying = (change.newValue ?? 0) > 0
        }
        
        context.coordinator.timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { time in
            let pos = time.seconds
            self.playPosition = pos
            context.coordinator.lastObservedPosition = pos
        }
        
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        
        let hostingVC = UIHostingController(rootView: overlay)
        playerVC.addChild(hostingVC)
        playerVC.contentOverlayView?.addSubview(hostingVC.view)
        hostingVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostingVC.didMove(toParent: playerVC)
        context.coordinator.hostingViewController = hostingVC
        
        return playerVC
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<Player>) {
        if context.coordinator.lastObservedPosition != playPosition {
            let time = CMTime(seconds: playPosition, preferredTimescale: 1)
            uiViewController.player?.seek(to: time)
        }
        guard let hc = context.coordinator.hostingViewController else { return }
        if let p = overlay {
            hc.rootView = p
            hc.view.isHidden = false
        } else {
            hc.view.isHidden = true
        }
    }
    
    static func dismantleUIViewController(_ uiViewController: AVPlayerViewController, coordinator: PlayerCoordinator<Overlay?>) {
        if let o = coordinator.timeObserver {
            uiViewController.player?.removeTimeObserver(o)
        }
    }
}

#if DEBUG
struct Player_Previews : PreviewProvider {
    static var previews: some View {
        Player(url: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8")!, isPlaying: .constant(false), playPosition: .constant(0), overlay: Text("sample overlay"))
    }
}
#endif
