//
//  GLVertexAttributes.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 08.10.2022.
//

import GLKit

enum GLVertexAttributes: GLuint {
  case position
  case origPosition
  case color
  case textureCoordinate
  case velocity

  func glName() -> String {
    switch self {
    case .color:
      return "color"
    case .position:
      return "position"
    case .origPosition:
      return "origPosition"
    case .textureCoordinate:
      return "textCoord"
    case .velocity:
      return "velocity"
    }
  }
}
