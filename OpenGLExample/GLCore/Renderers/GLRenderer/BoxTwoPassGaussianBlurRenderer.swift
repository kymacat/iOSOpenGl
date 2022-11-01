//
//  GLBoxTwoPassGaussianBlurRenderer.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 23.10.2022.
//

import GLKit

class BoxTwoPassGaussianBlurRenderer: GLRenderer {
  private let postProcessingProgram: GLProgram
  private let postProcessingMesh: GLMesh

  private var time: Float = 0
  private var frameBuffers: [GLuint] = [0, 0]
  private var texColorBuffers: [GLuint] = [0, 0]
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
    glDeleteFramebuffers(2, &frameBuffers)
    glDeleteRenderbuffers(1, &rboDepthStencil)
    glDeleteTextures(2, &texColorBuffers)
  }

  override func setup() {
    super.setup()
    postProcessingProgram.setup(attributes: postProcessingMesh.descriptor.attrubutes)
    postProcessingMesh.setup()

    // Create framebuffer
    glGenFramebuffers(2, &frameBuffers)

    // Create texture to hold color buffer
    glGenTextures(2, &texColorBuffers)

    let width = Int32(UIScreen.main.bounds.width * UIScreen.main.scale)
    let height = Int32(UIScreen.main.bounds.height * UIScreen.main.scale)

    // Set up the first framebuffer's color buffer
    glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBuffers[0])
    glActiveTexture(GLenum(GL_TEXTURE0))
    glBindTexture(GLenum(GL_TEXTURE_2D), texColorBuffers[0])

    glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGB, width, height, 0, GLenum(GL_RGB), GLenum(GL_UNSIGNED_BYTE), nil)
    glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR)
    glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR)
    glFramebufferTexture2D(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_TEXTURE_2D), texColorBuffers[0], 0)

    // Set up the second framebuffer's color buffer
    glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBuffers[1])
    glBindTexture(GLenum(GL_TEXTURE_2D), texColorBuffers[1])

    glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGB, width, height, 0, GLenum(GL_RGB), GLenum(GL_UNSIGNED_BYTE), nil)
    glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR)
    glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR)
    glFramebufferTexture2D(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_TEXTURE_2D), texColorBuffers[1], 0)

    // Create first Renderbuffer Object to hold depth and stencil buffers
    glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBuffers[0])

    glGenRenderbuffers(1, &rboDepthStencil)
    glBindRenderbuffer(GLenum(GL_RENDERBUFFER), rboDepthStencil)
    glRenderbufferStorage(GLenum(GL_RENDERBUFFER), GLenum(GL_DEPTH24_STENCIL8), width, height)
    glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_DEPTH_STENCIL_ATTACHMENT), GLenum(GL_RENDERBUFFER), rboDepthStencil)
  }

  override func glkViewControllerUpdate(_ controller: GLKViewController) {
    time += 1

    glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBuffers[0])
    program.prepareToDraw()
    mesh.prepareToDraw()
    drawBox(containerSize: controller.view.bounds.size)

    let textureOffsetUniform = glGetUniformLocation(postProcessingProgram.glProgram, GLShaderUniform.textureOffset.rawValue)

    glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBuffers[1])
    glBindTexture(GLenum(GL_TEXTURE_2D), texColorBuffers[0])
    postProcessingProgram.prepareToDraw()
    postProcessingMesh.prepareToDraw()
    glUniform2f(textureOffsetUniform, 1.0 / 300.0, 0.0)
    glDrawArrays(GLenum(GL_TRIANGLES), 0, 6)

    delegate?.bindDrawableFramebuffer()
    glBindTexture(GLenum(GL_TEXTURE_2D), texColorBuffers[1])
    postProcessingProgram.prepareToDraw()
    postProcessingMesh.prepareToDraw()
    glUniform2f(textureOffsetUniform, 0.0, 1.0 / 300.0)
    glDrawArrays(GLenum(GL_TRIANGLES), 0, 6)
  }

  private func drawBox(containerSize: CGSize) {
    glEnable(GLenum(GL_DEPTH_TEST))
    glClearColor(0.25, 0.25, 0.25, 1.0)
    glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))

    let colorLoc = glGetUniformLocation(program.glProgram, GLShaderUniform.overrideColor.rawValue)
    glUniform3f(colorLoc, 1.0, 1.0, 1.0)

    var model = GLKMatrix4.identity.rotate(rotationZ: time / 60)
    model.glFloatPointer {
      glUniformMatrix4fv(glGetUniformLocation(program.glProgram, GLShaderUniform.modelMatrix.rawValue), 1, 0, $0)
    }

    let view = GLKMatrix4(eye: [-1.8, -1.8, 1.8], center: [0.0, 0.0, 0.0], up: [0.0, 0.0, 1.0])
    view.glFloatPointer {
      glUniformMatrix4fv(glGetUniformLocation(program.glProgram, GLShaderUniform.viewMatrix.rawValue), 1, 0, $0)
    }

    let proj = GLKMatrix4(
      projectionFov: .pi / 2,
      near: 1,
      far: 10,
      aspect: Float(containerSize.width / containerSize.height)
    )
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
    glDisable(GLenum(GL_DEPTH_TEST))
  }
}

