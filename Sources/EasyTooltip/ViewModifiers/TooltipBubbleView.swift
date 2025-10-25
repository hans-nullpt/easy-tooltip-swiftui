//
//  TooltipBubbleView.swift
//  EasyTooltip
//
//  Created by Ivan Nur Ilham Syah on 25/10/25.
//

import SwiftUI

struct TooltipBubbleView<Content: View>: View {
  let placement: TooltipPlacement
  let arrowAlignment: CGFloat
  let arrowPixel: CGFloat?
  let cornerRadius: CGFloat
  let arrowSize: CGSize
  let background: Color
  let content: Content
  let onSizeChange: (CGSize) -> Void
  
  init(
    placement: TooltipPlacement,
    arrowAlignment: CGFloat,
    arrowPixel: CGFloat? = nil,
    cornerRadius: CGFloat = 12,
    arrowSize: CGSize = .init(width: 16, height: 10),
    background: Color = Color(.systemBackground),
    @ViewBuilder content: () -> Content,
    onSizeChange: @escaping (CGSize) -> Void
  ) {
    self.placement = placement
    self.arrowAlignment = arrowAlignment
    self.arrowPixel = arrowPixel
    self.cornerRadius = cornerRadius
    self.arrowSize = arrowSize
    self.background = background
    self.content = content()
    self.onSizeChange = onSizeChange
  }
  
  var body: some View {
    content
      .padding(10)
      .background(
        RoundedRectangle(cornerRadius: cornerRadius)
          .fill(background)
          .shadow(radius: 8, y: 4)
      )
      .overlay(arrowOverlay)
      .readSize(onSizeChange)
      .compositingGroup()
  }
  
  private func clamp<T: Comparable>(_ v: T, _ a: T, _ b: T) -> T { max(a, min(v, b)) }
  
  @ViewBuilder
  private var arrowOverlay: some View {
    GeometryReader { gp in
      let w = gp.size.width
      let h = gp.size.height
      
      let guardX = arrowSize.width * 0.5
      let guardY = cornerRadius + arrowSize.width * 0.5
      
      let pixelX: CGFloat = {
        if let px = arrowPixel { return clamp(px, guardX, w - guardX) }
        return clamp(arrowAlignment * w, guardX, w - guardX)
      }()
      
      switch placement {
      case .top:
        TooltipArrowShape(direction: .down)
          .fill(background)
          .frame(width: arrowSize.width, height: arrowSize.height)
          .position(x: pixelX, y: h + arrowSize.height * 0.5 - 0.5)
        
      case .bottom:
        TooltipArrowShape(direction: .up)
          .fill(background)
          .frame(width: arrowSize.width, height: arrowSize.height)
          .position(x: pixelX, y: 0 - arrowSize.height * 0.5 + 0.5)
        
      case .leading:
        TooltipArrowShape(direction: .right)
          .fill(background)
          .frame(width: arrowSize.height, height: arrowSize.width)
          .position(x: w + arrowSize.height * 0.5 - 0.5, y: h / 2)
        
      case .trailing, .auto:
        TooltipArrowShape(direction: .left)
          .fill(background)
          .frame(width: arrowSize.height, height: arrowSize.width)
          .position(x: 0 - arrowSize.height * 0.5 + 0.5, y: h / 2)
      }
    }
  }
}

struct TooltipArrowShape: Shape {
  enum Direction { case up, down, left, right }
  var direction: Direction
  
  func path(in rect: CGRect) -> Path {
    var p = Path()
    switch direction {
    case .up:
      p.move(to: CGPoint(x: rect.midX, y: rect.minY))
      p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
      p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
    case .down:
      p.move(to: CGPoint(x: rect.midX, y: rect.maxY))
      p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
      p.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
    case .left:
      p.move(to: CGPoint(x: rect.minX, y: rect.midY))
      p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
      p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    case .right:
      p.move(to: CGPoint(x: rect.maxX, y: rect.midY))
      p.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
      p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
    }
    p.closeSubpath()
    return p
  }
}
