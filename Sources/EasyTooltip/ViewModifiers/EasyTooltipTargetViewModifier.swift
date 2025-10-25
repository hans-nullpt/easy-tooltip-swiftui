//
//  EasyTooltipTargetViewModifier.swift
//  EasyTooltip
//
//  Created by Ivan Nur Ilham Syah on 25/10/25.
//

import SwiftUI

struct EasyTooltipTargetViewModifier: ViewModifier {
  @Environment(\.tooltipController) private var controller
  
  let id: UUID
  let text: String
  let placement: TooltipPlacement
  let gap: CGFloat
  
  func body(content: Content) -> some View {
    content
      .simultaneousGesture(
        TapGesture().onEnded {
          controller.tapTarget(id)
        }
      )
      .anchorPreference(key: TooltipPreferenceKey.self, value: .bounds) { anchor in
        [
          TooltipTargetPreference(id: id, text: text, anchor: anchor, placement: placement, gap: gap)
        ]
      }
  }
}
