//
//  EasyTooltipViewModifier.swift
//  EasyTooltip
//
//  Created by Ivan Nur Ilham Syah on 25/10/25.
//

import SwiftUI

struct EasyTooltipViewModifier: ViewModifier {
  let coordinateSpaceName = "TooltipSpace"
  
  @ObservedObject var controller: EasyTooltipController
  
  @State private var resolvedRects: [AnyHashable: CGRect] = [:]
  @State private var allTargets: [TooltipTargetPreference] = []
  
  func body(content: Content) -> some View {
    GeometryReader { proxy in
      ZStack {
        content
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .coordinateSpace(name: coordinateSpaceName)
          .backgroundPreferenceValue(TooltipPreferenceKey.self) { prefs in
            GeometryReader { proxy in
              let map: [AnyHashable: CGRect] = Dictionary(
                uniqueKeysWithValues: prefs.map { ($0.id, proxy[$0.anchor]) }
              )
              
              Color.clear
                .preference(key: ResolvedTooltipRectsKey.self, value: map)
                .onAppear { allTargets = prefs }
                .onChange(of: prefs) { allTargets = $0 }
            }
          }
          .simultaneousGesture(
            DragGesture(
              minimumDistance: 0,
              coordinateSpace: .named(coordinateSpaceName)
            )
            .onChanged { value in
              guard let id = controller.activeTargetID,
                    let target = resolvedRects[id]
              else { return }
              
              if !target.contains(value.location) {
                controller.dismiss()
              }
            }
          )
        
        TooltipOverlay(
          controller: controller,
          resolvedRects: resolvedRects,
          allTargets: allTargets,
          containerSize: proxy.size
        )
        .zIndex(9999)
      }
    }
    .tooltipController(controller)
    .onPreferenceChange(ResolvedTooltipRectsKey.self) { rects in
      self.resolvedRects = rects
    }
  }
  
  @ViewBuilder
  private func tooltipBubbleView(_ prefs: TooltipTargetPreference) -> some View {
    Text(prefs.text)
      .foregroundStyle(.white)
      .padding(10)
      .background(.black)
      .cornerRadius(8)
  }
}
