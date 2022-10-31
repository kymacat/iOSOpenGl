//
//  GLRendererModel.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 30.10.2022.
//

import Foundation

class GLRendererModel {
  let title: String
  let isImagePickerAvailable: Bool
  let buildClosure: () -> GLRenderer

  init(
    title: String,
    isImagePickerAvailable: Bool = false,
    buildClosure: @escaping () -> GLRenderer
  ) {
    self.title = title
    self.isImagePickerAvailable = isImagePickerAvailable
    self.buildClosure = buildClosure
  }
}
