//
//  ResolvedTooltipRectsKey.swift
//  EasyTooltip
//
//  Created by Ivan Nur Ilham Syah on 25/10/25.
//

import SwiftUI

struct ResolvedTooltipRectsKey: PreferenceKey {
  static var defaultValue: [AnyHashable: CGRect] = [:]
  
  static func reduce(value: inout [AnyHashable: CGRect], nextValue: () -> [AnyHashable: CGRect]) {
    value.merge(nextValue(), uniquingKeysWith: { $1 })
  }
}
