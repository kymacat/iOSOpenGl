//
//  GLRendererModel.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 30.10.2022.
//

import Foundation

class GLRendererModel {
  let title: String
  let buildClosure: () -> GLRenderer

  init(title: String, buildClosure: @escaping () -> GLRenderer) {
    self.title = title
    self.buildClosure = buildClosure
  }
}
