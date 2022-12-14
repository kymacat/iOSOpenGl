//
//  GLRenderer.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 09.10.2022.
//

import GLKit

class GLRenderer: NSObject, GLKViewControllerDelegate {
  private(set) var program: GLProgram
  private(set) var mesh: GLMesh

  weak var delegate: GLRendererDelegate?

  init(program: GLProgram, mesh: GLMesh) {
    self.program = program
    self.mesh = mesh
  }

  func changeProgram(new program: GLProgram) {
    self.program = program
    program.setup(attributes: mesh.descriptor.attrubutes)
  }

  func setup() {
    program.setup(attributes: mesh.descriptor.attrubutes)
    mesh.setup()
  }

  func glkViewControllerUpdate(_ controller: GLKViewController) {
    program.prepareToDraw()
    mesh.prepareToDraw()

    glClearColor(0.25, 0.25, 0.25, 1.0)
    glClear(GLbitfield(GL_COLOR_BUFFER_BIT))

    glDrawElements(GLenum(GL_TRIANGLES), GLsizei(mesh.indexes.count), GLenum(GL_UNSIGNED_INT), nil)
  }

  // For overriding

  func touchesBegan(_ touches: Set<UITouch>, in view: UIView) {}
  func touchesMoved(_ touches: Set<UITouch>, in view: UIView) {}
  func touchesEnded(_ touches: Set<UITouch>, in view: UIView) {}
  func changeTextures(_ textures: [GLTexture]) {}
  func changeSensitivity(_ sensitivity: Float) {}
  func orientationChanged(_ isPortrait: Bool) {}
}
