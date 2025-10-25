//
//  Debouncer.swift
//  EasyTooltip
//
//  Created by Ivan Nur Ilham Syah on 25/10/25.
//

import Foundation

class Debouncer {
  private var workItem: DispatchWorkItem?
  private let interval: TimeInterval
  
  init(interval: TimeInterval) {
    self.interval = interval
  }
  
  func call(_ block: @escaping () -> Void) {
    workItem?.cancel()
    let item = DispatchWorkItem(block: block)
    workItem = item
    DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: item)
  }
  
  func cancel() {
    workItem?.cancel()
  }
  
  deinit {
    cancel()
  }
}
