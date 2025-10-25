//
//  File.swift
//  EasyTooltip
//
//  Created by Ivan Nur Ilham Syah on 25/10/25.
//

import SwiftUI

extension View {
  func readSize(_ onChange: @escaping (CGSize) -> Void) -> some View {
    background(
      GeometryReader { proxy in
        Color.clear
          .preference(key: SizePreferenceKey.self, value: proxy.size)
      }
    )
    .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
  }
  
  func tooltipController(_ controller: EasyTooltipController) -> some View {
    environment(\.tooltipController, controller)
  }
  
  func easyTooltip(_ controller: EasyTooltipController) -> some View {
    modifier(EasyTooltipViewModifier(controller: controller))
  }
}
