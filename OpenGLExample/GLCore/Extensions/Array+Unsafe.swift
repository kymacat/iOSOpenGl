//
//  Array+GL.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 29.10.2022.
//

import GLKit

extension Array where Element == String {
  func cPoiners() -> UnsafePointer<UnsafePointer<GLchar>?> {
    let cPointers = map { $0.toCPointer() }

    let unsafeBufferPointer = UnsafeMutablePointer<UnsafePointer<GLchar>?>.allocate(capacity: count)

    for (index, pointer) in cPointers.enumerated() {
      unsafeBufferPointer.advanced(by: index).pointee = pointer
    }

    return UnsafePointer<UnsafePointer<GLchar>?>(unsafeBufferPointer)
  }
}
