//
//  GLEffect.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 08.10.2022.
//

import Foundation
import GLKit

class GLProgram {
  private let vertexShaderName: String
  private let fragmentShaderName: String
  private let attributes: [GLVertexAttributes]

  private(set) var glProgram: GLuint = 0
  private var vertexShader: GLuint = 0
  private var fragmentShader: GLuint = 0

  init(vertexShader: GLShader, fragmentShader: GLShader, attributes: [GLVertexAttributes]) {
    self.vertexShaderName = vertexShader.rawValue
    self.fragmentShaderName = fragmentShader.rawValue
    self.attributes = attributes
  }

  deinit {
    glDeleteProgram(glProgram)
    glDeleteShader(fragmentShader)
    glDeleteShader(vertexShader)
  }

  func setup() {
    compile(vertexShader: vertexShaderName, fragmentShader: fragmentShaderName, attributes: attributes)
  }

  func prepareToDraw() {
    glUseProgram(glProgram)
  }

  private func compile(vertexShader: String, fragmentShader: String, attributes: [GLVertexAttributes]) {
    self.vertexShader = compileShader(name: vertexShader, type: GLenum(GL_VERTEX_SHADER))
    self.fragmentShader = compileShader(name: fragmentShader, type: GLenum(GL_FRAGMENT_SHADER))

    self.glProgram = glCreateProgram()
    glAttachShader(glProgram, self.vertexShader)
    glAttachShader(glProgram, self.fragmentShader)

    for attribute in attributes {
      glBindAttribLocation(glProgram, attribute.rawValue, attribute.glName())
    }
    
    glLinkProgram(glProgram)

    var success: GLint = 1
    glGetProgramiv(glProgram, GLenum(GL_LINK_STATUS), &success)
    if success == GL_FALSE {
      let infoLog = UnsafeMutablePointer<GLchar>.allocate(capacity: 512)
      glGetProgramInfoLog(glProgram, 512, nil, infoLog)
      assertionFailure("link program error. \(String.init(cString: infoLog))")
    }
  }

  private func compileShader(name: String, type: GLenum) -> GLuint {
    guard let shaderUrl = Bundle.main.url(forResource: name, withExtension: "glsl"),
          let shaderStr = try? String(contentsOf: shaderUrl, encoding: .utf8)
    else {
      assertionFailure("Shader \(name).glsl not found")
      return 0
    }

    let shader = glCreateShader(type)
    var cShaderSource = (shaderStr as NSString).utf8String
    glShaderSource(shader, 1, &cShaderSource, nil)
    glCompileShader(shader)

    var success: GLint = 1
    glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &success)
    if success == GL_FALSE {
      let infoLog = UnsafeMutablePointer<GLchar>.allocate(capacity: 512)
      glGetShaderInfoLog(shader, 512, nil, &infoLog.pointee)
      assertionFailure("\(name).glsl compile error. \(String(cString: infoLog))")
    }

    return shader
  }
}
