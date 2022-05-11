//
//  Comparable+Extension.swift
//  ExGestures
//
//  Created by Jake.K on 2022/05/11.
//

import Foundation

// https://stackoverflow.com/a/40868784
extension Comparable {
  func clamped(to limits: ClosedRange<Self>) -> Self {
    min(max(self, limits.lowerBound), limits.upperBound)
  }
}
