//
//  EasyTooltipController.swift
//  EasyTooltip
//
//  Created by Ivan Nur Ilham Syah on 25/10/25.
//

import Foundation
import SwiftUI

public class EasyTooltipController: ObservableObject {
  @Published var isPresented = false
  @Published var activeTargetID: AnyHashable? = nil

  private var pendingID: AnyHashable? = nil

  func tapTarget(_ id: AnyHashable) {
    if activeTargetID == id {
      dismiss()
      return
    }
    
    show(id)
  }
  
  func show(_ id: AnyHashable) {
    activeTargetID = nil
    
    guard isPresented else {
      activeTargetID = id
      isPresented = true
      return
    }
    
    pendingID = id
    isPresented = false

    DispatchQueue.main.async { [weak self] in
      guard let self = self, let next = self.pendingID else { return }
      self.activeTargetID = next
      self.isPresented = true
      self.pendingID = nil
    }
  }

  func dismiss() {
    pendingID = nil
    isPresented = false
  }
}


private struct EasyTooltipControllerKey: EnvironmentKey {
  static let defaultValue: EasyTooltipController = .init()
}

extension EnvironmentValues {
  var tooltipController: EasyTooltipController {
    get { self[EasyTooltipControllerKey.self] }
    set { self[EasyTooltipControllerKey.self] = newValue }
  }
}
