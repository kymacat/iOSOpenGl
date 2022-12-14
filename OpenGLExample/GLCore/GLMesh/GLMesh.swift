//
//  GLMesh.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 09.10.2022.
//

import GLKit

class GLMesh {
  let verticesData: [GLfloat]
  let indexes: [GLuint]
  let descriptor: GLMeshDescriptor

  var verticesCount: GLsizei { GLsizei(verticesData.count / descriptor.stride) }

  private var vertexArrayObject: GLuint = 0
  private var vertexBufferObject: GLuint = 0
  private var elementBufferObject: GLuint = 0

  init(
    verticesData: [GLfloat],
    indexes: [GLuint],
    descriptor: GLMeshDescriptor
  ) {
    self.verticesData = verticesData
    self.indexes = indexes
    self.descriptor = descriptor
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
      MemoryLayout<GLfloat>.stride * verticesData.count,
      verticesData,
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

    descriptor.setup()
  }

  func prepareToDraw() {
    glBindVertexArray(vertexArrayObject)
    glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBufferObject)
    glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), elementBufferObject)
  }
}

extension GLMesh {
  static var points: GLMesh {
    GLMesh(
      verticesData: [
        -0.45,  0.45,
         0.45,  0.45,
         0.45, -0.45,
         -0.45, -0.45
      ],
      indexes: [],
      descriptor: Points2DDescriptor()
    )
  }

  static var triangle: GLMesh {
    GLMesh(
      verticesData: [
//       x    y    r    g    b
        0.0, 0.5, 1.0, 0.0, 0.0,
        0.5, -0.5, 0.0, 1.0, 0.0,
        -0.5, -0.5, 0.0, 0.0, 1.0
      ],
      indexes: [
        0, 1, 2
      ],
      descriptor: Object2DWithColorDescriptor()
    )
  }

  static var rectangle: GLMesh {
    GLMesh(
      verticesData: [
//        x    y    r    g    b
        -0.5, 0.5, 1.0, 0.0, 0.0,
         0.5, 0.5, 0.0, 1.0, 0.0,
         0.5, -0.5, 0.0, 0.0, 1.0,
         -0.5, -0.5, 1.0, 1.0, 1.0
      ],
      indexes: [
        0, 1, 2,
        2, 3, 0
      ],
      descriptor: Object2DWithColorDescriptor()
    )
  }

  static var rectangleWithTexture: GLMesh {
    GLMesh(
      verticesData: [
//        x    y   z   texX  texY
        -0.5, 0.5, 0.0, 0.0, 0.0,
         0.5, 0.5, 0.0, 1.0, 0.0,
         0.5, -0.5, 0.0, 1.0, 1.0,
         -0.5, -0.5, 0.0, 0.0, 1.0
      ],
      indexes: [
        0, 1, 2,
        2, 3, 0
      ],
      descriptor: Object3DWithTextureDescriptor()
    )
  }

  static var boxWithFloor: GLMesh {
    GLMesh(
      verticesData: [
//       Position         Color
        -0.5, -0.5, -0.5, 0.96, 0.79, 0.65,
        0.5, -0.5, -0.5, 0.8, 0.94, 0.9,
        0.5,  0.5, -0.5, 0.28, 0.56, 0.16,
        0.5,  0.5, -0.5, 0.28, 0.56, 0.16,
        -0.5,  0.5, -0.5, 0.6, 0.9, 0.88,
        -0.5, -0.5, -0.5, 0.96, 0.79, 0.65,

        -0.5, -0.5,  0.5, 1.0, 0.86, 0.37,
        0.5, -0.5,  0.5, 0.64, 0.05, 0.85,
        0.5,  0.5,  0.5, 0.55, 0.83, 0.75,
        0.5,  0.5,  0.5, 0.55, 0.83, 0.75,
        -0.5,  0.5,  0.5, 0.74, 0.97, 0.47,
        -0.5, -0.5,  0.5, 1.0, 0.86, 0.37,

        -0.5,  0.5,  0.5, 0.61, 0.48, 0.70,
        -0.5,  0.5, -0.5, 0.83, 0.99, 0.32,
        -0.5, -0.5, -0.5, 0.53, 0.93, 0.22,
        -0.5, -0.5, -0.5, 0.53, 0.93, 0.22,
        -0.5, -0.5,  0.5, 0.33, 0.41, 0.83,
        -0.5,  0.5,  0.5, 0.61, 0.48, 0.70,

        0.5,  0.5,  0.5, 0.84, 0.06, 0.85,
        0.5,  0.5, -0.5, 0.34, 0.36, 0.99,
        0.5, -0.5, -0.5, 0.21, 0.78, 0.1,
        0.5, -0.5, -0.5, 0.21, 0.78, 0.1,
        0.5, -0.5,  0.5, 0.8, 0.22, 0.87,
        0.5,  0.5,  0.5, 0.84, 0.06, 0.85,

        -0.5, -0.5, -0.5, 0.05, 0.58, 0.83,
        0.5, -0.5, -0.5, 0.17, 0.87, 1.0,
        0.5, -0.5,  0.5, 0.38, 0.95, 0.57,
        0.5, -0.5,  0.5, 0.38, 0.95, 0.57,
        -0.5, -0.5,  0.5, 0.12, 0.16, 0.17,
        -0.5, -0.5, -0.5, 0.05, 0.58, 0.83,

        -0.5,  0.5, -0.5, 0.7, 0.27, 0.01,
        0.5,  0.5, -0.5, 0.17, 0.58, 0.21,
        0.5,  0.5,  0.5, 0.22, 0.84, 0.63,
        0.5,  0.5,  0.5, 0.22, 0.84, 0.63,
        -0.5,  0.5,  0.5, 0.1, 0.42, 0.25,
        -0.5,  0.5, -0.5, 0.7, 0.27, 0.01,

        -1.0, -1.0, -0.5, 0.0, 0.0, 0.0,
        1.0, -1.0, -0.5, 0.0, 0.0, 0.0,
        1.0,  1.0, -0.5, 0.0, 0.0, 0.0,
        1.0,  1.0, -0.5, 0.0, 0.0, 0.0,
        -1.0, 1.0, -0.5, 0.0, 0.0, 0.0,
        -1.0, -1.0, -0.5, 0.0, 0.0, 0.0
      ],
      indexes: [],
      descriptor: Object3DWithColorDescriptor()
    )
  }

  static var fullScreenTexture: GLMesh {
    GLMesh(
      verticesData: [
        -1.0,  1.0,  0.0, 1.0,
         1.0,  1.0,  1.0, 1.0,
         1.0, -1.0,  1.0, 0.0,

         1.0, -1.0,  1.0, 0.0,
         -1.0, -1.0,  0.0, 0.0,
         -1.0,  1.0,  0.0, 1.0
      ],
      indexes: [],
      descriptor: Object2DWithTextureDescriptor()
    )
  }

  static var fullScreenRevercedTexture: GLMesh {
    GLMesh(
      verticesData: [
        -1.0,  1.0,  0.0, 0.0,
         1.0,  1.0,  1.0, 0.0,
         1.0, -1.0,  1.0, 1.0,
         -1.0, -1.0,  0.0, 1.0
      ],
      indexes: [
        0, 1, 2,
        0, 2, 3
      ],
      descriptor: Object2DWithTextureDescriptor()
    )
  }

  static var gravityPoints: GLMesh {
    var verticesData = Array(repeating: GLfloat(0), count: 600)

    for y in 0 ..< 10 {
      for x in 0 ..< 10 {
        let xPosition = 0.2 * GLfloat(x) - 0.9
        let yPosition = 0.2 * GLfloat(y) - 0.9

        verticesData[60 * y + 6 * x] = xPosition
        verticesData[60 * y + 6 * x + 1] = yPosition
        verticesData[60 * y + 6 * x + 4] = xPosition
        verticesData[60 * y + 6 * x + 5] = yPosition
      }
    }

    return GLMesh(
      verticesData: verticesData,
      indexes: [],
      descriptor: GravityPointsDescriptor()
    )
  }
}
