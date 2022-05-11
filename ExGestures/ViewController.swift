//
//  ViewController.swift
//  ExGestures
//
//  Created by Jake.K on 2022/05/11.
//

import UIKit

class ViewController: UIViewController {
  private let gesture = RightToLeftSwipeGestureRecognizer()
  private var animator: UIViewPropertyAnimator?
  private var views = Mock.getViews()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.views.forEach {
      self.view.addSubview($0)
      $0.alpha = 0
      $0.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        $0.leftAnchor.constraint(equalTo: self.view.leftAnchor),
        $0.rightAnchor.constraint(equalTo: self.view.rightAnchor),
        $0.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        $0.topAnchor.constraint(equalTo: self.view.topAnchor),
      ])
    }
    
    self.views.first?.alpha = 1
    self.view.addGestureRecognizer(self.gesture)
    self.gesture.addTarget(self, action: #selector(handleGesture(_:)))
  }
  
  @objc private func handleGesture(_ gesture: UIPanGestureRecognizer) {
    switch gesture.state {
    case .began:
      self.view.isUserInteractionEnabled = false
      self.animator = self.getNextAnimator()
    case .changed:
      let translationX = -gesture.translation(in: self.view).x / self.view.bounds.width
      let fractionComplete = translationX.clamped(to: 0...1)
      guard self.animator?.fractionComplete != fractionComplete else { break }
      self.animator?.fractionComplete = fractionComplete
    case
      .ended,
      .cancelled
    :
      self.animator?.isReversed = gesture.velocity(in: self.view).x > -200 || gesture.state == .cancelled
      self.animator?.startAnimation() // isReversed를 사용하면 다시 active해야하므로
    default:
      break
    }
  }
  
  private func getNextAnimator() -> UIViewPropertyAnimator? {
    self.animator?.stopAnimation(false) // true인 경우 completionHandler호출없이 inactive상태, false인 경우 애니메이션이 멈춘 Stopped상태 (finishAnimation과 같이 사용)
    self.animator?.finishAnimation(at: .end) // completion handler 호출, inactive 상태로 전환
    
    guard self.views.count > 1 else { return nil }
    let currentView = self.views[0]
    let nextView = self.views[1]
    
    // Init
    let animator = UIViewPropertyAnimator(
      duration: 0.5,
      timingParameters: UICubicTimingParameters(animationCurve: .easeInOut)
    )
    
    // Animation
    animator.addAnimations {
      UIView.animate(withDuration: 1) {
        currentView.transform = .init(translationX: -UIScreen.main.bounds.width, y: 0)
        nextView.alpha = 1
      }
    }
    
    // Completion
    animator.addCompletion { [weak self, weak currentView] position in
      self?.view.isUserInteractionEnabled = true
      guard
        position == .end && animator.isReversed == false,
        let currentView = currentView,
        self?.views.isEmpty == false
      else { return }
      
      currentView.removeFromSuperview()
      self?.views.removeFirst()
      
      guard self?.animator === animator else { return }
      self?.animator = nil
    }
    
    return animator
  }
}

