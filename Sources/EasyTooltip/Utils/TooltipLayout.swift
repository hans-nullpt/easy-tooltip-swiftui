//
//  TooltipLayout.swift
//  EasyTooltip
//
//  Created by Ivan Nur Ilham Syah on 25/10/25.
//

import Foundation

enum TooltipLayout {
  static func compute(_ i: TooltipLayoutInput) -> TooltipLayoutResult {
    let cs = i.containerSize
    
    let minX = i.margins.left + i.safeArea.left
    let maxX = cs.width - i.margins.right - i.safeArea.right
    let minY = i.margins.top + i.safeArea.top
    let maxY = cs.height - i.margins.bottom - max(i.safeArea.bottom, i.keyboardHeight)
    
    let spaceAbove = i.targetRect.minY - minY
    let spaceBelow = maxY - i.targetRect.maxY
    let spaceLeft  = i.targetRect.minX - minX
    let spaceRight = maxX - i.targetRect.maxX
    
    let placement: TooltipPlacement = {
      switch i.preferred {
      case .top:     return (spaceAbove >= i.tooltipSize.height + i.gap) ? .top : .bottom
      case .bottom:  return (spaceBelow >= i.tooltipSize.height + i.gap) ? .bottom : .top
      case .leading: return (spaceLeft  >= i.tooltipSize.width  + i.gap) ? .leading : .trailing
      case .trailing:return (spaceRight >= i.tooltipSize.width  + i.gap) ? .trailing : .leading
      case .auto:
        let candidates: [(TooltipPlacement, CGFloat)] = [
          (.bottom, spaceBelow),
          (.top, spaceAbove),
          (.trailing, spaceRight),
          (.leading, spaceLeft)
        ]
        return candidates.max(by: { $0.1 < $1.1 })?.0 ?? .bottom
      }
    }()
    
    var origin = CGPoint.zero
    switch placement {
    case .top:
      origin.y = i.targetRect.minY - i.gap - i.tooltipSize.height
      origin.x = i.targetRect.midX - i.tooltipSize.width/2
    case .bottom:
      origin.y = i.targetRect.maxY + i.gap
      origin.x = i.targetRect.midX - i.tooltipSize.width/2
    case .leading:
      origin.x = i.targetRect.minX - i.gap - i.tooltipSize.width
      origin.y = i.targetRect.midY - i.tooltipSize.height/2
    case .trailing:
      origin.x = i.targetRect.maxX + i.gap
      origin.y = i.targetRect.midY - i.tooltipSize.height/2
    case .auto: fatalError("resolved above")
    }
    
    let clampedX = max(minX, min(origin.x, maxX - i.tooltipSize.width))
    let clampedY = max(minY, min(origin.y, maxY - i.tooltipSize.height))
    let frame = CGRect(origin: .init(x: clampedX, y: clampedY), size: i.tooltipSize)
    
    let arrowAlignment: CGFloat = {
      switch placement {
      case .top, .bottom:
        let raw = (i.targetRect.midX - frame.minX) / frame.width
        return max(0.9, min(raw, 0.92))
      case .leading, .trailing:
        let raw = (i.targetRect.midY - frame.minY) / frame.height
        return max(0.08, min(raw, 0.92))
      case .auto: fatalError("resolved above")
      }
    }()
    
    let normalized = TooltipLayoutResult.Normalized(
      origin: CGPoint(x: frame.minX / cs.width, y: frame.minY / cs.height),
      size: CGSize(width: frame.width / cs.width, height: frame.height / cs.height)
    )
    
    return .init(
      frame: frame,
      placement: placement,
      arrowAlignment: arrowAlignment,
      normalized: normalized
    )
  }
  
  static func denormalize(
    _ n: TooltipLayoutResult.Normalized,
    in container: CGSize
  ) -> CGRect {
    .init(
      x: n.origin.x * container.width,
      y: n.origin.y * container.height,
      width: n.size.width * container.width,
      height: n.size.height * container.height
    )
  }
}
