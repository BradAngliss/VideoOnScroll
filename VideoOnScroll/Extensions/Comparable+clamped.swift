//
//  Comparable+clamped.swift
//  VideoOnScroll
//
//  Created by Brad Angliss on 17/01/2025.
//

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
