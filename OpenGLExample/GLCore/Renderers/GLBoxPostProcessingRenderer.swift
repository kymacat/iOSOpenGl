//
//  GLBoxPostProcessingRenderer.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 20.10.2022.
//

import GLKit

class GLBoxPostProcessingRenderer: GLBoxWithMirroringRenderer {
  var frameBuffer: GLuint = 0

  private let postProcessingEffect: GLEffect
  private let postProcessingMesh: GLMesh

  init(
    shader: GLEffect,
    mesh: GLMesh,
    postProcessingEffect: GLEffect,
    postProcessingMesh: GLMesh
  ) {
    self.postProcessingEffect = postProcessingEffect
    self.postProcessingMesh = postProcessingMesh
    super.init(shader: shader, mesh: mesh)
  }


  override func setup() {
    super.setup()
    postProcessingEffect.setup()
    postProcessingMesh.setup()

    // Create framebuffer
    glGenFramebuffers(1, &frameBuffer)
    glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBuffer)

    // Create texture to hold color buffer
    var texColorBuffer: GLuint = 0
    glGenTextures(1, &texColorBuffer)
    glBindTexture(GLenum(GL_TEXTURE_2D), texColorBuffer)

    let width = Int32(UIScreen.main.bounds.width * UIScreen.main.scale)
    let height = Int32(UIScreen.main.bounds.height * UIScreen.main.scale)
    glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGB, width, height, 0, GLenum(GL_RGB), GLenum(GL_UNSIGNED_BYTE), nil)

    glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR)
    glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR)

    glFramebufferTexture2D(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_TEXTURE_2D), texColorBuffer, 0)

    // Create Renderbuffer Object to hold depth and stencil buffers
    var rboDepthStencil: GLuint = 0
    glGenRenderbuffers(1, &rboDepthStencil)
    glBindRenderbuffer(GLenum(GL_RENDERBUFFER), rboDepthStencil)
    glRenderbufferStorage(GLenum(GL_RENDERBUFFER), GLenum(GL_DEPTH24_STENCIL8), width, height)
    glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_DEPTH_STENCIL_ATTACHMENT), GLenum(GL_RENDERBUFFER), rboDepthStencil)
  }

  override func glkViewControllerUpdate(_ controller: GLKViewController) {
    time += 1

    effect.prepareToDraw()
    mesh.prepareToDraw()

    glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBuffer)
    glEnable(GLenum(GL_DEPTH_TEST))

    glClearColor(0.25, 0.25, 0.25, 1.0)
    glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))

    let colorLoc = glGetUniformLocation(effect.glProgram, "overrideColor")
    glUniform3f(colorLoc, 1.0, 1.0, 1.0)

    var model = GLKMatrix4.identity.rotate(rotationZ: time / 60)
    model.glFloatPointer { glUniformMatrix4fv(glGetUniformLocation(effect.glProgram, "model"), 1, 1, $0) }

    var view = GLKMatrix4(eye: [-1.8, -1.8, 1.8], center: [0.0, 0.0, 0.0], up: [0.0, 0.0, 1.0])
    view.glFloatPointer { glUniformMatrix4fv(glGetUniformLocation(effect.glProgram, "view"), 1, 0, $0) }

    var proj = GLKMatrix4(
      projectionFov: .pi / 2,
      near: 1,
      far: 10,
      aspect: Float(controller.view.bounds.width / controller.view.bounds.height)
    )
    proj.glFloatPointer { glUniformMatrix4fv(glGetUniformLocation(effect.glProgram, "proj"), 1, 0, $0) }

    glDrawArrays(GLenum(GL_TRIANGLES), 0, 36)

    glEnable(GLenum(GL_STENCIL_TEST))

    // Draw floor
    glStencilFunc(GLenum(GL_ALWAYS), 1, 0xFF) // Set any stencil to 1
    glStencilOp(GLenum(GL_KEEP), GLenum(GL_KEEP), GLenum(GL_REPLACE))
    glStencilMask(0xFF)  // Write to stencil buffer
    glDepthMask(GLboolean(GL_FALSE)) // Don't write to depth buffer
    glClear(GLbitfield(GL_STENCIL_BUFFER_BIT)) // Clear stencil buffer (0 by default)
    glDrawArrays(GLenum(GL_TRIANGLES), 36, 6)

    // Draw cube reflection
    glStencilFunc(GLenum(GL_EQUAL), 1, 0xFF) // Pass test if stencil value is 1
    glStencilMask(0x00) // Don't write anything to stencil buffer
    glDepthMask(GLboolean(GL_TRUE)) // Write to depth buffer

    model = model.translate(translation: [0, 0, -1]).scale(scaling: [1, 1, -1])
    model.glFloatPointer { glUniformMatrix4fv(glGetUniformLocation(effect.glProgram, "model"), 1, 1, $0) }

    glUniform3f(colorLoc, 0.3, 0.3, 0.3)
    glDrawArrays(GLenum(GL_TRIANGLES), 0, 36)

    glDisable(GLenum(GL_STENCIL_TEST))
    glDisable(GLenum(GL_DEPTH_TEST))

    glBindFramebuffer(GLenum(GL_FRAMEBUFFER), 2)
    postProcessingEffect.prepareToDraw()
    postProcessingMesh.prepareToDraw()

    glDrawArrays(GLenum(GL_TRIANGLES), 0, 6)
  }
}
