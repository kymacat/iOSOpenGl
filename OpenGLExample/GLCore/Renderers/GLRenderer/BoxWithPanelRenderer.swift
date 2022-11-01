//
//  GLBoxWithPanelRenderer.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 23.10.2022.
//

import GLKit

class BoxWithPanelRenderer: GLRenderer {
  private let postProcessingProgram: GLProgram
  private let postProcessingMesh: GLMesh

  private var time: Float = 0
  private var frameBuffer: GLuint = 0
  private var texColorBuffer: GLuint = 0
  private var rboDepthStencil: GLuint = 0

  init(
    program: GLProgram,
    mesh: GLMesh,
    postProcessingProgram: GLProgram,
    postProcessingMesh: GLMesh
  ) {
    self.postProcessingProgram = postProcessingProgram
    self.postProcessingMesh = postProcessingMesh
    super.init(program: program, mesh: mesh)
  }

  deinit {
    glDeleteFramebuffers(1, &frameBuffer)
    glDeleteRenderbuffers(1, &rboDepthStencil)
    glDeleteTextures(1, [texColorBuffer])
  }

  override func setup() {
    super.setup()
    postProcessingProgram.setup(attributes: postProcessingMesh.descriptor.attrubutes)
    postProcessingMesh.setup()

    // Create framebuffer
    glGenFramebuffers(1, &frameBuffer)
    glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBuffer)

    // Create texture to hold color buffer
    glGenTextures(1, &texColorBuffer)
    glActiveTexture(GLenum(GL_TEXTURE0))
    glBindTexture(GLenum(GL_TEXTURE_2D), texColorBuffer)

    let width = Int32(UIScreen.main.bounds.width * UIScreen.main.scale)
    let height = Int32(UIScreen.main.bounds.height * UIScreen.main.scale)
    glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGB, width, height, 0, GLenum(GL_RGB), GLenum(GL_UNSIGNED_BYTE), nil)

    glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR)
    glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR)

    glFramebufferTexture2D(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_TEXTURE_2D), texColorBuffer, 0)

    // Create Renderbuffer Object to hold depth and stencil buffers
    glGenRenderbuffers(1, &rboDepthStencil)
    glBindRenderbuffer(GLenum(GL_RENDERBUFFER), rboDepthStencil)
    glRenderbufferStorage(GLenum(GL_RENDERBUFFER), GLenum(GL_DEPTH24_STENCIL8), width, height)
    glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_DEPTH_STENCIL_ATTACHMENT), GLenum(GL_RENDERBUFFER), rboDepthStencil)
  }

  override func glkViewControllerUpdate(_ controller: GLKViewController) {
    time += 1

    let mirrorView = GLKMatrix4(eye: [0, 2.5, 0.5], center: [0.0, 0.0, 0.0], up: [0.0, 0.0, 1.0])
    let normalView = GLKMatrix4(eye: [1.8, -1.8, 1.8], center: [0.0, 0.0, 0.0], up: [0.0, 0.0, 1.0])
    let proj = GLKMatrix4(
      projectionFov: .pi / 2,
      near: 1,
      far: 10,
      aspect: Float(controller.view.bounds.width / controller.view.bounds.height)
    )

    glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBuffer)
    glClearColor(1.0, 1.0, 1.0, 1.0)
    glEnable(GLenum(GL_DEPTH_TEST))
    glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))
    program.prepareToDraw()
    mesh.prepareToDraw()
    drawBox(view: mirrorView, proj: proj)

    delegate?.bindDrawableFramebuffer()
    glClearColor(0.25, 0.25, 0.25, 1.0)
    glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))
    postProcessingProgram.prepareToDraw()
    postProcessingMesh.prepareToDraw()
    drawPanel(view: normalView, proj: proj)

    program.prepareToDraw()
    mesh.prepareToDraw()
    drawBox(view: normalView, proj: proj)

    glDisable(GLenum(GL_DEPTH_TEST))
  }

  private func drawPanel(view: GLKMatrix4, proj: GLKMatrix4) {
    let model = GLKMatrix4.identity.rotate(rotationX: .pi / 2).translate(translation: [0, 2.5, 0])
    model.glFloatPointer {
      glUniformMatrix4fv(glGetUniformLocation(postProcessingProgram.glProgram, GLShaderUniform.modelMatrix.rawValue), 1, 0, $0)
    }

    view.glFloatPointer {
      glUniformMatrix4fv(glGetUniformLocation(postProcessingProgram.glProgram, GLShaderUniform.viewMatrix.rawValue), 1, 0, $0)
    }

    proj.glFloatPointer {
      glUniformMatrix4fv(glGetUniformLocation(postProcessingProgram.glProgram, GLShaderUniform.projectionMatrix.rawValue), 1, 0, $0)
    }
    glDrawArrays(GLenum(GL_TRIANGLES), 0, 6)
  }

  private func drawBox(view: GLKMatrix4, proj: GLKMatrix4) {
    let colorLoc = glGetUniformLocation(program.glProgram, GLShaderUniform.overrideColor.rawValue)
    glUniform3f(colorLoc, 1.0, 1.0, 1.0)

    var model = GLKMatrix4.identity.rotate(rotationZ: time / 60)
    model.glFloatPointer {
      glUniformMatrix4fv(glGetUniformLocation(program.glProgram, GLShaderUniform.modelMatrix.rawValue), 1, 0, $0)
    }

    view.glFloatPointer {
      glUniformMatrix4fv(glGetUniformLocation(program.glProgram, GLShaderUniform.viewMatrix.rawValue), 1, 0, $0)
    }

    proj.glFloatPointer {
      glUniformMatrix4fv(glGetUniformLocation(program.glProgram, GLShaderUniform.projectionMatrix.rawValue), 1, 0, $0)
    }

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
    model.glFloatPointer {
      glUniformMatrix4fv(glGetUniformLocation(program.glProgram, GLShaderUniform.modelMatrix.rawValue), 1, 0, $0)
    }

    glUniform3f(colorLoc, 0.3, 0.3, 0.3)
    glDrawArrays(GLenum(GL_TRIANGLES), 0, 36)

    glDisable(GLenum(GL_STENCIL_TEST))
  }
}
