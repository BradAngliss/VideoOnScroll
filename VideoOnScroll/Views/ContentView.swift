//
//  ContentView.swift
//  VideoOnScroll
//
//  Created by Brad Angliss on 17/01/2025.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @StateObject var viewModel: ViewModel
    @State private var scrollOffset: CGFloat = 0

    init() {
        self._viewModel = StateObject(wrappedValue: ViewModel())
    }

    var body: some View {
        VideoPlayer(player: viewModel.player)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                viewModel.setScreenHeight(UIScreen.main.bounds.height)
            }
            .ignoresSafeArea()
            .aspectRatio(contentMode: .fill)
            .overlay {
                GeometryReader { geometry in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            ZStack{
                                EmptyView()
                            }
                            .frame(
                                width: geometry.size.width,
                                height: geometry.size.height
                            )

                            ForEach(viewModel.displayContent, id: \.self) { content in
                                DisplayContentView(content: content)
                                    .frame(
                                        width: geometry.size.width,
                                        height: geometry.size.height
                                    )
                            }
                        }
                        .background(GeometryReader { proxy in
                            Color.clear.preference(key: ScrollOffsetKey.self, value: proxy.frame(in: .named("scroll")).maxY)
                                .onAppear { viewModel.setScrollViewHeight(proxy.size.height) }
                        })
                        .onPreferenceChange(ScrollOffsetKey.self) {
                            viewModel.setVideoSeekPosition(offset: $0)
                        }
                    }
                    .coordinateSpace(name: "scroll")
                }
            }
    }

    struct ScrollOffsetKey: PreferenceKey {
        static var defaultValue = CGFloat.zero
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value += nextValue()
        }
    }
}

#Preview {
    ContentView()
}
