//
//  Mock.swift
//  ExGestures
//
//  Created by Jake.K on 2022/05/11.
//

import UIKit

private var randomColor: UIColor {
  UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
}

enum Mock {
  static func getViews() -> [UIView] {
    (0...30).map {
      let view = UIView()
      
      // label
      let label = UILabel()
      label.text = "\($0) 번째 뷰"
      label.textColor = .black
      label.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(label)
      NSLayoutConstraint.activate([
        view.centerYAnchor.constraint(equalTo: label.centerYAnchor),
        view.centerXAnchor.constraint(equalTo: label.centerXAnchor),
      ])
      view.backgroundColor = randomColor
      return view
    }
  }
}
