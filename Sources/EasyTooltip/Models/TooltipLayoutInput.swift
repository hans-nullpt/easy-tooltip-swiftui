//
//  TooltipLayoutInput.swift
//  EasyTooltip
//
//  Created by Ivan Nur Ilham Syah on 25/10/25.
//

import UIKit

struct TooltipLayoutInput {
  var targetRect: CGRect
  var containerSize: CGSize
  var tooltipSize: CGSize
  var preferred: TooltipPlacement = .auto
  var gap: CGFloat = 8
  var margins: UIEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
  var safeArea: UIEdgeInsets = .zero
  var keyboardHeight: CGFloat = 0
}
