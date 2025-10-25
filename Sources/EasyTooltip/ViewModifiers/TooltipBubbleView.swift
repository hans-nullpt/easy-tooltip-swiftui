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
  let arrowSize: CGSize
  let style: EasyTooltipStyle
  let content: Content
  let onSizeChange: (CGSize) -> Void
  
  init(
    placement: TooltipPlacement,
    arrowAlignment: CGFloat,
    arrowPixel: CGFloat? = nil,
    arrowSize: CGSize = .init(width: 16, height: 10),
    style: EasyTooltipStyle,
    @ViewBuilder content: () -> Content,
    onSizeChange: @escaping (CGSize) -> Void
  ) {
    self.placement = placement
    self.arrowAlignment = arrowAlignment
    self.arrowPixel = arrowPixel
    self.arrowSize = arrowSize
    self.style = style
    self.content = content()
    self.onSizeChange = onSizeChange
  }
  
  var body: some View {
    let shape = TooltipBubbleShape(
      placement: placement,
      cornerRadius: style.cornerRadius,
      arrowSize: arrowSize,
      arrowAlignment: arrowAlignment,
      arrowPixel: arrowPixel,
      apexRadius: style.cornerRadius / 2
    )
    
    content
      .padding(10)
      .background(
        shape
          .fill(style.backgroundColor)
          .shadow(radius: 8, y: 4)
      )
      .overlay(
        shape
          .stroke(style.borderColor, lineWidth: style.borderWidth)
      )
      .readSize(onSizeChange)
  }
  
  private func clamp<T: Comparable>(_ v: T, _ a: T, _ b: T) -> T { max(a, min(v, b)) }
}

struct TooltipBubbleShape: InsettableShape {
  let placement: TooltipPlacement
  let cornerRadius: CGFloat
  let arrowSize: CGSize
  let arrowAlignment: CGFloat
  let arrowPixel: CGFloat?
  let apexRadius: CGFloat
  
  var insetAmount: CGFloat = 0
  
  func inset(by amount: CGFloat) -> TooltipBubbleShape {
    var copy = self
    copy.insetAmount += amount
    return copy
  }
  
  func path(in rect: CGRect) -> Path {
    let r = rect.insetBy(dx: insetAmount, dy: insetAmount)
    let aw = arrowSize.width
    let ah = arrowSize.height
    
    func clamp<T: Comparable>(_ v: T, _ a: T, _ b: T) -> T { max(a, min(v, b)) }
    
    func roundedApexPoints(apex: CGPoint, base: CGPoint) -> CGPoint {
      let dx = base.x - apex.x
      let dy = base.y - apex.y
      let len = max(0.0001, hypot(dx, dy))
      let ux = dx / len
      let uy = dy / len
      return CGPoint(x: apex.x + ux * apexRadius, y: apex.y + uy * apexRadius)
    }
    
    var p = Path()
    
    switch placement {
    case .bottom:
      let guardX = cornerRadius + aw * 0.5
      let px = arrowPixel ?? clamp(arrowAlignment * r.width, guardX, r.width - guardX)
      let baseL = CGPoint(x: r.minX + px - aw * 0.5, y: r.minY)
      let baseR = CGPoint(x: r.minX + px + aw * 0.5, y: r.minY)
      let apex  = CGPoint(x: r.minX + px, y: r.minY - ah)
      let nearL = roundedApexPoints(apex: apex, base: baseL)
      let nearR = roundedApexPoints(apex: apex, base: baseR)
      
      p.move(to: CGPoint(x: r.minX + cornerRadius, y: r.minY))
      if baseL.x > r.minX + cornerRadius {
        p.addLine(to: baseL)
      }
      p.addLine(to: nearL)
      p.addQuadCurve(to: nearR, control: apex)
      p.addLine(to: baseR)
      p.addLine(to: CGPoint(x: r.maxX - cornerRadius, y: r.minY))
      p.addArc(
        center: CGPoint(
          x: r.maxX - cornerRadius,
          y: r.minY + cornerRadius
        ),
        radius: cornerRadius,
        startAngle: .degrees(270),
        endAngle: .degrees(0),
        clockwise: false
      )
      p.addLine(to: CGPoint(x: r.maxX, y: r.maxY - cornerRadius))
      p.addArc(
        center: CGPoint(
          x: r.maxX - cornerRadius,
          y: r.maxY - cornerRadius
        ),
        radius: cornerRadius,
        startAngle: .degrees(0),
        endAngle: .degrees(90),
        clockwise: false
      )
      p.addLine(to: CGPoint(x: r.minX + cornerRadius, y: r.maxY))
      p.addArc(
        center: CGPoint(
          x: r.minX + cornerRadius,
          y: r.maxY - cornerRadius
        ),
        radius: cornerRadius,
        startAngle: .degrees(90),
        endAngle: .degrees(180),
        clockwise: false
      )
      p.addLine(to: CGPoint(x: r.minX, y: r.minY + cornerRadius))
      p.addArc(
        center: CGPoint(
          x: r.minX + cornerRadius,
          y: r.minY + cornerRadius
        ),
        radius: cornerRadius,
        startAngle: .degrees(180),
        endAngle: .degrees(270),
        clockwise: false
      )
      
    case .top:
      let guardX = cornerRadius + aw * 0.5
      let px = arrowPixel ?? clamp(arrowAlignment * r.width, guardX, r.width - guardX)
      let baseL = CGPoint(x: r.minX + px - aw * 0.5, y: r.maxY)
      let baseR = CGPoint(x: r.minX + px + aw * 0.5, y: r.maxY)
      let apex  = CGPoint(x: r.minX + px, y: r.maxY + ah)
      let nearL = roundedApexPoints(apex: apex, base: baseL)
      let nearR = roundedApexPoints(apex: apex, base: baseR)
      
      p.move(to: CGPoint(x: r.minX + cornerRadius, y: r.minY))
      p.addLine(to: CGPoint(x: r.maxX - cornerRadius, y: r.minY))
      p.addArc(
        center: CGPoint(
          x: r.maxX - cornerRadius,
          y: r.minY + cornerRadius
        ),
        radius: cornerRadius,
        startAngle: .degrees(270),
        endAngle: .degrees(0),
        clockwise: false
      )
      p.addLine(to: CGPoint(x: r.maxX, y: r.maxY - cornerRadius))
      p.addArc(
        center: CGPoint(
          x: r.maxX - cornerRadius,
          y: r.maxY - cornerRadius
        ),
        radius: cornerRadius,
        startAngle: .degrees(0),
        endAngle: .degrees(90),
        clockwise: false
      )
      p.addLine(to: baseL)
      p.addLine(to: nearL)
      p.addQuadCurve(to: nearR, control: apex)
      p.addLine(to: baseR)
      p.addLine(to: CGPoint(x: r.minX + cornerRadius, y: r.maxY))
      p.addArc(
        center: CGPoint(
          x: r.minX + cornerRadius,
          y: r.maxY - cornerRadius
        ),
        radius: cornerRadius,
        startAngle: .degrees(90),
        endAngle: .degrees(180),
        clockwise: false
      )
      p.addLine(to: CGPoint(x: r.minX, y: r.minY + cornerRadius))
      p.addArc(
        center: CGPoint(
          x: r.minX + cornerRadius,
          y: r.minY + cornerRadius
        ),
        radius: cornerRadius,
        startAngle: .degrees(180),
        endAngle: .degrees(270),
        clockwise: false
      )
      
    case .leading:
      let guardY = cornerRadius + aw * 0.5
      let py = arrowPixel ?? clamp(arrowAlignment * r.height, guardY, r.height - guardY)
      let baseT = CGPoint(x: r.maxX, y: r.minY + py - aw * 0.5)
      let baseB = CGPoint(x: r.maxX, y: r.minY + py + aw * 0.5)
      let apex  = CGPoint(x: r.maxX + ah, y: r.minY + py)
      let nearT = roundedApexPoints(apex: apex, base: baseT)
      let nearB = roundedApexPoints(apex: apex, base: baseB)
      
      p.move(to: CGPoint(x: r.minX + cornerRadius, y: r.minY))
      p.addLine(to: CGPoint(x: r.maxX - cornerRadius, y: r.minY))
      p.addArc(
        center: CGPoint(
          x: r.maxX - cornerRadius,
          y: r.minY + cornerRadius
        ),
        radius: cornerRadius,
        startAngle: .degrees(270),
        endAngle: .degrees(0),
        clockwise: false
      )
      p.addLine(to: baseT)
      p.addLine(to: nearT)
      p.addQuadCurve(to: nearB, control: apex)
      p.addLine(to: baseB)
      p.addLine(to: CGPoint(x: r.maxX, y: r.maxY - cornerRadius))
      p.addArc(
        center: CGPoint(
          x: r.maxX - cornerRadius,
          y: r.maxY - cornerRadius
        ),
        radius: cornerRadius,
        startAngle: .degrees(0),
        endAngle: .degrees(90),
        clockwise: false
      )
      p.addLine(to: CGPoint(x: r.minX + cornerRadius, y: r.maxY))
      p.addArc(
        center: CGPoint(
          x: r.minX + cornerRadius,
          y: r.maxY - cornerRadius
        ),
        radius: cornerRadius,
        startAngle: .degrees(90),
        endAngle: .degrees(180),
        clockwise: false
      )
      p.addLine(to: CGPoint(x: r.minX, y: r.minY + cornerRadius))
      p.addArc(
        center: CGPoint(
          x: r.minX + cornerRadius,
          y: r.minY + cornerRadius
        ),
        radius: cornerRadius,
        startAngle: .degrees(180),
        endAngle: .degrees(270),
        clockwise: false
      )
      
    case .trailing, .auto:
      let guardY = cornerRadius + aw * 0.5
      let py = arrowPixel ?? clamp(arrowAlignment * r.height, guardY, r.height - guardY)
      let baseT = CGPoint(x: r.minX, y: r.minY + py - aw * 0.5)
      let baseB = CGPoint(x: r.minX, y: r.minY + py + aw * 0.5)
      let apex  = CGPoint(x: r.minX - ah, y: r.minY + py)
      let nearT = roundedApexPoints(apex: apex, base: baseT)
      let nearB = roundedApexPoints(apex: apex, base: baseB)
      
      p.move(to: CGPoint(x: r.minX + cornerRadius, y: r.minY))
      p.addLine(to: CGPoint(x: r.maxX - cornerRadius, y: r.minY))
      p.addArc(
        center: CGPoint(
          x: r.maxX - cornerRadius,
          y: r.minY + cornerRadius
        ),
        radius: cornerRadius,
        startAngle: .degrees(270),
        endAngle: .degrees(0),
        clockwise: false
      )
      p.addLine(to: CGPoint(x: r.maxX, y: r.maxY - cornerRadius))
      p.addArc(
        center: CGPoint(
          x: r.maxX - cornerRadius,
          y: r.maxY - cornerRadius
        ),
        radius: cornerRadius,
        startAngle: .degrees(0),
        endAngle: .degrees(90),
        clockwise: false
      )
      p.addLine(to: CGPoint(x: r.minX + cornerRadius, y: r.maxY))
      p.addArc(
        center: CGPoint(
          x: r.minX + cornerRadius,
          y: r.maxY - cornerRadius
        ),
        radius: cornerRadius,
        startAngle: .degrees(90),
        endAngle: .degrees(180),
        clockwise: false
      )
      p.addLine(to: baseB)
      p.addLine(to: nearB)
      p.addQuadCurve(to: nearT, control: apex)
      p.addLine(to: baseT)
      p.addLine(to: CGPoint(x: r.minX, y: r.minY + cornerRadius))
      p.addArc(
        center: CGPoint(
          x: r.minX + cornerRadius,
          y: r.minY + cornerRadius
        ),
        radius: cornerRadius,
        startAngle: .degrees(180),
        endAngle: .degrees(270),
        clockwise: false
      )
    }
    
    p.closeSubpath()
    return p
  }
}
