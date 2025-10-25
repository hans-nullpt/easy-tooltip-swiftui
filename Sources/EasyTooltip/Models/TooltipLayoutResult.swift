//
//  TooltipLayoutResult.swift
//  EasyTooltip
//
//  Created by Ivan Nur Ilham Syah on 25/10/25.
//

import Foundation

struct TooltipLayoutResult {
  var frame: CGRect
  var placement: TooltipPlacement
  var arrowAlignment: CGFloat
  var normalized: Normalized
  
  struct Normalized {
    var origin: CGPoint
    var size: CGSize
  }
}
