//
//  GLMesh.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 09.10.2022.
//

import GLKit

class GLMesh {
  let vertices: [GLfloat]
  let indexes: [GLuint]

  private var vertexArrayObject: GLuint = 0
  private var vertexBufferObject: GLuint = 0
  private var elementBufferObject: GLuint = 0

  init(vertices: [GLfloat], indexes: [GLuint]) {
    self.vertices = vertices
    self.indexes = indexes
  }

  deinit {
    glDeleteBuffers(1, &elementBufferObject)
    glDeleteBuffers(1, &vertexBufferObject)
    glDeleteVertexArrays(1, &vertexArrayObject)
  }

  func setup() {
    glGenVertexArrays(1, &vertexArrayObject)
    glBindVertexArray(vertexArrayObject)

    glGenBuffers(1, &vertexBufferObject)
    glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBufferObject)
    glBufferData(
      GLenum(GL_ARRAY_BUFFER),
      MemoryLayout<GLfloat>.stride * vertices.count,
      vertices,
      GLenum(GL_STATIC_DRAW)
    )

    glGenBuffers(1, &elementBufferObject)
    glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), elementBufferObject)
    glBufferData(
      GLenum(GL_ELEMENT_ARRAY_BUFFER),
      MemoryLayout<GLuint>.stride * indexes.count,
      indexes,
      GLenum(GL_STATIC_DRAW)
    )
  }
}

extension GLMesh {
  static let triangle = GLMesh(
    vertices: [
      0.0, 0.5, 1.0, 0.0, 0.0,
      0.5, -0.5, 0.0, 1.0, 0.0,
      -0.5, -0.5, 0.0, 0.0, 1.0
    ],
    indexes: [
      0, 1, 2
    ]
  )

  static let rectangle = GLMesh(
    vertices: [
      -0.5, 0.5, 1.0, 0.0, 0.0,
       0.5, 0.5, 0.0, 1.0, 0.0,
       0.5, -0.5, 0.0, 0.0, 1.0,
       -0.5, -0.5, 1.0, 1.0, 1.0
    ],
    indexes: [
      0, 1, 2,
      2, 3, 0
    ]
  )
}
