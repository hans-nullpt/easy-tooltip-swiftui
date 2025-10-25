//
//  TooltipOverlay.swift
//  EasyTooltip
//
//  Created by Ivan Nur Ilham Syah on 25/10/25.
//

import SwiftUI

struct TooltipOverlay: View {
  @ObservedObject var controller: EasyTooltipController
  
  let resolvedRects: [AnyHashable: CGRect]
  let allTargets: [TooltipTargetPreference]
  let containerSize: CGSize
  
  @State private var tooltipSize: CGSize = .zero
  @State private var appeared = false
  @State private var debouncer = Debouncer(interval: 0.2)
  
  private var activePref: TooltipTargetPreference? {
    guard let id = controller.activeTargetID else { return nil }
    return allTargets.first(where: { $0.id == id })
  }
  private var activeRect: CGRect? {
    guard let id = controller.activeTargetID else { return nil }
    return resolvedRects[id]
  }
  
  var body: some View {
    ZStack {
      if let pref = activePref, let rect = activeRect {
        let input = TooltipLayoutInput(
          targetRect: rect,
          containerSize: containerSize,
          tooltipSize: tooltipSize == .zero ? CGSize(width: 180, height: 44) : tooltipSize,
          preferred: pref.placement,
          gap: pref.gap,
          margins: .init(top: 8, left: 8, bottom: 8, right: 16),
          safeArea: .zero,
          keyboardHeight: 0
        )
        let result = TooltipLayout.compute(input)
        let bubbleFrame = result.frame
        
        let startYOffset = result.placement == .bottom ? -(rect.height) : rect.height
        
        let start = CGPoint(x: bubbleFrame.midX, y: bubbleFrame.midY + startYOffset)
        let end   = CGPoint(x: bubbleFrame.midX + 6, y: bubbleFrame.midY)
        
        let arrowPixel: CGFloat = switch result.placement {
        case .top, .bottom:
          rect.midX - bubbleFrame.minX - 6
        case .leading, .trailing, .auto:
          rect.midY - bubbleFrame.minY
        }
        
        let scaleAnchor: UnitPoint = scaleAnchor(
          placement: result.placement,
          bubbleSize: bubbleFrame.size,
          arrowPixel: arrowPixel
        )
        
        // BUBBLE
        TooltipBubbleView(
          placement: result.placement,
          arrowAlignment: result.arrowAlignment,
          arrowPixel: arrowPixel,
          style: controller.style
        ) {
          Text(pref.text)
            .font(controller.style.font)
            .foregroundColor(controller.style.foregroundColor)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: containerSize.width, alignment: .leading)
        } onSizeChange: { newSize in
          tooltipSize = newSize
        }
        .scaleEffect(appeared ? 1 : 0.5, anchor: scaleAnchor)
        .frame(width: bubbleFrame.width, height: result.frame.height, alignment: .center)
        .position(appeared ? end : start)
        .id(controller.activeTargetID)
        .opacity(appeared ? 1.0 : 0.0)
        .onAppear {
          appeared = true
        }
      }
    }
    .onChange(of: controller.isPresented) { shown in
      withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
        appeared = shown
      }
      
      debouncer.call {
        if !shown { controller.activeTargetID = nil }
      }
    }
    .allowsHitTesting(controller.isPresented)
  }
  
  private func scaleAnchor(
    placement: TooltipPlacement,
    bubbleSize: CGSize,
    arrowPixel: CGFloat
  ) -> UnitPoint {
    
    @inline(__always)
    func clamp(_ v: CGFloat, inset: CGFloat = 0.02) -> CGFloat {
      let lo = inset, hi = 1 - inset
      return max(lo, min(v, hi))
    }
    
    switch placement {
    case .top:
      let x = clamp(arrowPixel / max(bubbleSize.width, 1))
      return UnitPoint(x: x, y: 1)
    case .bottom:
      let x = clamp(arrowPixel / max(bubbleSize.width, 1))
      return UnitPoint(x: x, y: 0)
    case .leading:
      let y = clamp(arrowPixel / max(bubbleSize.height, 1))
      return UnitPoint(x: 1, y: y)
    case .trailing, .auto:
      let y = clamp(arrowPixel / max(bubbleSize.height, 1))
      return UnitPoint(x: 0, y: y)
    }
  }
}
