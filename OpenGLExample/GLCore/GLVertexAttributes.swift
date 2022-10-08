//
//  GLVertexAttributes.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 08.10.2022.
//

import GLKit

enum GLVertexAttributes: GLuint {
  case position
  case color

  func glName() -> String {
    switch self {
    case .color:
      return "color"
    case .position:
      return "position"
    }
  }
}
