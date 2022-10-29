//
//  String+GL.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 29.10.2022.
//

import GLKit

extension String {
  func toCPointer() -> UnsafePointer<GLchar> {
    let buffer = UnsafeMutablePointer<GLchar>.allocate(capacity: utf8CString.count)

    utf8CString.withUnsafeBytes { rawPointer in
      let typed = rawPointer.bindMemory(to: GLchar.self)

      for (index, batch) in typed.enumerated() {
        buffer.advanced(by: index).pointee = batch
      }
    }

    return UnsafePointer<GLchar>(buffer)
  }
}
