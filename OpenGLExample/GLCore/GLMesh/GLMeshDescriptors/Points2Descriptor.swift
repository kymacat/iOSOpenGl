//
//  Points2Descriptor.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 23.10.2022.
//

import GLKit

class Points2DDescriptor: GLMeshDescriptor {
  let stride = 2

  var attrubutes: [GLVertexAttributes] = [
    GLVertexAttributes.position
  ]

  func setup() {
    glEnableVertexAttribArray(GLVertexAttributes.position.rawValue)
    glVertexAttribPointer(
      GLVertexAttributes.position.rawValue,
      2,
      GLenum(GL_FLOAT),
      GLboolean(GL_FALSE),
      GLsizei(stride * MemoryLayout<GLfloat>.stride),
      nil
    )
  }

  deinit {
    attrubutes.forEach { glDisableVertexAttribArray($0.rawValue) }
  }
}
