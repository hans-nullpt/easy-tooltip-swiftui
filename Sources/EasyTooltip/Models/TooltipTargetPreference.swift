//
//  TooltipTargetPreference.swift
//  EasyTooltip
//
//  Created by Ivan Nur Ilham Syah on 25/10/25.
//

import SwiftUI

struct TooltipTargetPreference: Identifiable, Equatable {
  let id: AnyHashable
  let text: String
  let anchor: Anchor<CGRect>
  let placement: TooltipPlacement
  let gap: CGFloat
}
