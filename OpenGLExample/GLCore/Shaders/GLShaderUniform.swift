//
//  GLShaderAttribute.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 23.10.2022.
//

import Foundation

enum GLShaderUniform: String {
  case time
  case overrideColor
  case textureOffset = "texOffset"

  case modelMatrix = "model"
  case viewMatrix = "view"
  case projectionMatrix = "proj"

  case fingerPosition
  case gravity
  case speed

  case screenAspectRatio
  case textureAspectRatio
}
