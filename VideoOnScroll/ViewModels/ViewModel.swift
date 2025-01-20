//
//  ViewModel.swift
//  VideoOnScroll
//
//  Created by Brad Angliss on 17/01/2025.
//

import SwiftUI
import AVKit

extension ContentView {
    final class ViewModel: ObservableObject {
        let playerController = AVPlayerViewController()
        let player = AVPlayer(url: Bundle.main.url(forResource: "background", withExtension: "mp4")!)
        let displayContent: [DisplayContent] = [
            .init(text: "This is some text", subtext: "This is some subtext", animationDelay: 2, alignment: .leading),
            .init(text: "This is some other text", subtext: "This is some subtext", animationDelay: 2, alignment: .trailing),
        ]

        private var scrollViewHeight: CGFloat = 0
        private var screenHeight: CGFloat = 0
        private var duration: CMTime = .init()
        private var isSeekInProgress = false
        private var chaseTime = CMTime.zero

        init() {
            playerController.player = player
            playerController.showsPlaybackControls = false
            player.automaticallyWaitsToMinimizeStalling = true
            getPlayerDuration()
        }

        func setVideoSeekPosition(offset: CGFloat) {
            let actualOffset = scrollViewHeight - offset
            let seekPositionRatio = (actualOffset / scrollViewHeight).clamped(to: 0.0...1.0)
            let seekPosition = CMTimeMultiplyByFloat64(duration, multiplier: seekPositionRatio)
            if !(duration.value == 0 && duration.timescale == 0) {
                //            player.seek(to: seekPosition)
                seek(to: seekPosition)
            }
        }

        func setScreenHeight(_ height: CGFloat) {
            self.screenHeight = height
            print("Height >> \(height)")
        }

        func setScrollViewHeight(_ height: CGFloat) {
            self.scrollViewHeight = height
        }

        private func getPlayerDuration() {
            Task {
                self.duration = try! await (self.player.currentItem?.asset.load(.duration))!
            }
        }

        public func seek(to time: CMTime) {
                seekSmoothlyToTime(newChaseTime: time)
            }
            
            private func seekSmoothlyToTime(newChaseTime: CMTime) {
                if CMTimeCompare(newChaseTime, chaseTime) != 0 {
                    chaseTime = newChaseTime
                    
                    if !isSeekInProgress {
                        trySeekToChaseTime()
                    }
                }
            }
            
            private func trySeekToChaseTime() {
                guard player.status == .readyToPlay else { return }
                actuallySeekToTime()
            }
            
            private func actuallySeekToTime() {
                isSeekInProgress = true
                let seekTimeInProgress = chaseTime
                
                player.seek(to: seekTimeInProgress, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] _ in
                    guard let `self` = self else { return }
                    
                    if CMTimeCompare(seekTimeInProgress, self.chaseTime) == 0 {
                        self.isSeekInProgress = false
                    } else {
                        self.trySeekToChaseTime()
                    }
                }
            }
    }
}
