//
//  DisplayContent.swift
//  VideoOnScroll
//
//  Created by Brad Angliss on 18/01/2025.
//

import SwiftUI

struct DisplayContent: Hashable {
    private var identifier: String {
        return UUID().uuidString
    }
    var text: String
    var subtext: String
    var animationDelay: Double
    var alignment: Alignment

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }

    static func arrange() -> DisplayContent {
        return .init(text: "This is some text", subtext: "This is some subtext", animationDelay: 0, alignment: .leading)
    }
}
