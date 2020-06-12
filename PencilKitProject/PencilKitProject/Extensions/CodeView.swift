//
//  CodeView.swift
//  PencilKitProject
//
//  Created by gustavo.quenca on 12/06/20.
//  Copyright © 2020 gustavo.quenca. All rights reserved.
//

import Foundation
public protocol CodeView {
  func buildViewHierarchy()
  func setupConstraints()
  func setupAdditionalConfiguration()
  func setupView()
}

extension CodeView {
  public func setupView() {
    buildViewHierarchy()
    setupConstraints()
    setupAdditionalConfiguration()
  }
  
  public func setupAdditionalConfiguration() {}
}
