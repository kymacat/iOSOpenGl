//
//  GravityPointsRenderer.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 26.10.2022.
//

import GLKit

class GLGravityPointsRenderer: GLRenderer {
  private lazy var tboSize = mesh.verticesData.count * 4 / mesh.descriptor.stride
  private lazy var startedVertexData = mesh.verticesData
  private var fingerPosition: float2?

  override func setup() {
    super.setup()

    var transferBufferObject: GLuint = 0
    glGenBuffers(1, &transferBufferObject)
    glBindBuffer(GLenum(GL_ARRAY_BUFFER), transferBufferObject)
    glBufferData(GLenum(GL_ARRAY_BUFFER), tboSize * MemoryLayout<GLfloat>.stride, nil, GLenum(GL_DYNAMIC_READ))

    glBindBufferBase(GLenum(GL_TRANSFORM_FEEDBACK_BUFFER), 0, transferBufferObject)
  }

  override func glkViewControllerUpdate(_ controller: GLKViewController) {
    program.prepareToDraw()
    mesh.prepareToDraw()

    glUniform1f(glGetUniformLocation(program.glProgram, GLShaderUniform.gravity.rawValue), 1.5)
    glUniform1f(glGetUniformLocation(program.glProgram, GLShaderUniform.speed.rawValue), 0.033)

    var currPosition: float2 = [.infinity, .infinity]
    if let fingerPosition = fingerPosition {
      currPosition = [
        (fingerPosition.x / GLfloat(controller.view.bounds.width) - 0.5) * 2,
        (1 - fingerPosition.y / GLfloat(controller.view.bounds.height) - 0.5) * 2
      ]
    }

    glUniform2f(
      glGetUniformLocation(program.glProgram, GLShaderUniform.fingerPosition.rawValue),
      currPosition.x,
      currPosition.y
    )

    glClearColor(0.0, 0.0, 0.0, 1.0)
    glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
    glBeginTransformFeedback(GLenum(GL_POINTS))
    glDrawArrays(GLenum(GL_POINTS), 0, mesh.verticesCount)
    glEndTransformFeedback()
    updateBufferData()
  }

  private func updateBufferData() {
    let tfbPointer = glMapBufferRange(
      GLenum(GL_TRANSFORM_FEEDBACK_BUFFER),
      0,
      tboSize * MemoryLayout<GLfloat>.stride,
      GLbitfield(GL_MAP_WRITE_BIT | GL_MAP_READ_BIT)
    )

    if let tfbPointer = tfbPointer {
      let typedPointer = tfbPointer.bindMemory(to: GLfloat.self, capacity: tboSize)

      let bufferPointer = UnsafeBufferPointer(start: typedPointer, count: tboSize)
      for i in 0 ..< Int(mesh.verticesCount) {
        startedVertexData[6 * i] = bufferPointer[4 * i]
        startedVertexData[6 * i + 1] = bufferPointer[4 * i + 1]
        startedVertexData[6 * i + 2] = bufferPointer[4 * i + 2]
        startedVertexData[6 * i + 3] = bufferPointer[4 * i + 3]
      }

      startedVertexData.withUnsafeBufferPointer { bufferPointer in
        let unsafeMutablePointer = UnsafeMutablePointer<GLfloat>.allocate(capacity: bufferPointer.count)

        for (index, element) in bufferPointer.enumerated() {
          unsafeMutablePointer.advanced(by: index).pointee = element
        }

        glBufferSubData(GLenum(GL_ARRAY_BUFFER), 0, startedVertexData.count * MemoryLayout<GLfloat>.stride, unsafeMutablePointer)
        unsafeMutablePointer.deallocate()
      }
    }

    glUnmapBuffer(GLenum(GL_TRANSFORM_FEEDBACK_BUFFER))
  }

  override func touchesBegan(_ touches: Set<UITouch>, in view: UIView) {
    guard let location = touches.first?.location(in: view) else { return }
    fingerPosition = [GLfloat(location.x), GLfloat(location.y)]
  }

  override func touchesMoved(_ touches: Set<UITouch>, in view: UIView) {
    guard let location = touches.first?.location(in: view) else { return }
    fingerPosition = [GLfloat(location.x), GLfloat(location.y)]
  }

  override func touchesEnded(_ touches: Set<UITouch>, in view: UIView) {
    fingerPosition = nil
  }
}

