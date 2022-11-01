//
//  Object2DWithTextureDescriptor.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 21.10.2022.
//

import GLKit

class Object2DWithTextureDescriptor: GLMeshDescriptor {
  let stride = 4

  var attrubutes: [GLVertexAttributes] = [
    GLVertexAttributes.position,
    GLVertexAttributes.textureCoordinate
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

    glEnableVertexAttribArray(GLVertexAttributes.textureCoordinate.rawValue)
    glVertexAttribPointer(
      GLVertexAttributes.textureCoordinate.rawValue,
      2,
      GLenum(GL_FLOAT),
      GLboolean(GL_FALSE),
      GLsizei(stride * MemoryLayout<GLfloat>.stride),
      UnsafeRawPointer(bitPattern: 2 * MemoryLayout<GLfloat>.stride)
    )
  }

  deinit {
    attrubutes.forEach { glDisableVertexAttribArray($0.rawValue) }
  }
}
