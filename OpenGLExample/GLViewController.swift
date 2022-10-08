//
//  ViewController.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 04.10.2022.
//

import UIKit
import GLKit

class GLViewController: GLKViewController {
  private var context: EAGLContext?
  private let renderer = GLRenderer(
    shader: GLEffect(vertexShader: .simpleVertex, fragmentShader: .simpleFragment, attributes: [.position, .color]),
    mesh: .triangle
  )

  override func viewDidLoad() {
    super.viewDidLoad()
    setupGL()
  }

  private func setupGL() {
    context = EAGLContext(api: .openGLES3)
    EAGLContext.setCurrent(context)

    if let view = self.view as? GLKView, let context = context {
      view.context = context
      delegate = renderer
    }

    renderer.setup()
  }
}

