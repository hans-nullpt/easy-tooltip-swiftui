//
//  TooltipPreferenceKey.swift
//  EasyTooltip
//
//  Created by Ivan Nur Ilham Syah on 25/10/25.
//

import SwiftUI

struct TooltipPreferenceKey: PreferenceKey {
  static var defaultValue: [TooltipTargetPreference] = []
  static func reduce(value: inout [TooltipTargetPreference], nextValue: () -> [TooltipTargetPreference]) {
    value.append(contentsOf: nextValue())
  }
}
