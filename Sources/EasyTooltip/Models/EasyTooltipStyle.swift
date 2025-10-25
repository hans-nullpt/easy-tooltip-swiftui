//
//  EasyTooltipStyle.swift
//  EasyTooltip
//
//  Created by Ivan Nur Ilham Syah on 25/10/25.
//

import SwiftUI

public protocol EasyTooltipStyle {
  var font: Font { get }
  var backgroundColor: Color { get }
  var foregroundColor: Color { get }
  var cornerRadius: CGFloat { get }
  var borderWidth: CGFloat { get }
  var borderColor: Color { get }
}

public class DefaultTooltipStyle: EasyTooltipStyle {
  public init() { }
  
  public var font: Font {
    .body
  }
  
  public var backgroundColor: Color {
    .black
  }
  
  public var foregroundColor: Color {
    .white
  }
  
  public var cornerRadius: CGFloat {
    8
  }
  
  public var borderWidth: CGFloat {
    2
  }
  
  public var borderColor: Color {
    .clear
  }
}
