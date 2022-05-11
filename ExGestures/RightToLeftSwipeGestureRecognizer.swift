//
//  RightToLeftSwipeGestureRecognizer.swift
//  ExGestures
//
//  Created by Jake.K on 2022/05/11.
//

import UIKit

final class RightToLeftSwipeGestureRecognizer: UIPanGestureRecognizer {
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesMoved(touches, with: event)
    guard let view = self.view, self.state == .began else { return }
    
    // x가 더 크면 좌우로 스와이프, y가 더 크면 위 아래로 스와이프
    // magnitude가 음수이면
    if velocity(in: view).x.magnitude > velocity(in: view).y.magnitude {
      velocity(in: view).x < 0 ? print("우->좌") : print("좌->우")
    } else {
      velocity(in: view).y < 0 ? print("하->상") : print("상->하")
    }
    
    guard
      velocity(in: view).x.magnitude > velocity(in: view).y.magnitude, // 수평 스와이프
      velocity(in: view).x < 0 // 우 -> 좌 스와이프
    else {
      self.state = .failed
      return
    }
  }
}
