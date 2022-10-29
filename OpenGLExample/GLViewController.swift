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
  private var renderer: GLRenderer = .gravityPointsRenderer

  override func viewDidLoad() {
    super.viewDidLoad()
    setupGL()
  }

  private func setupGL() {
    context = EAGLContext(api: .openGLES3)
    EAGLContext.setCurrent(context)

    if let view = self.view as? GLKView, let context = context {
      view.context = context
      view.drawableDepthFormat = .format24
      view.drawableStencilFormat = .format8
      delegate = renderer
    }

    renderer.setup()
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    renderer.touchesBegan(touches, in: view)
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    renderer.touchesMoved(touches, in: view)
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    renderer.touchesEnded(touches, in: view)
  }
}

