//
//  GLKMatrix4+GL.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 29.10.2022.
//

import GLKit

extension GLKMatrix4 {
  var count: Int { 16 }

  func glFloatPointer(callback: (UnsafePointer<GLfloat>) -> Void) {
    var matrix = m
    withUnsafePointer(to: &matrix) {
      $0.withMemoryRebound(to: GLfloat.self, capacity: count) {
        callback($0)
      }
    }
  }
}
