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
  private var renderer: GLRenderer = .boxWithMirroringRenderer

  private lazy var settingsButton: UIButton = {
    let button = UIButton(type: .system)
    button.tintColor = .white
    button.setImage(.init(systemName: "gearshape"), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupGL()
    setupSubviews()
  }

  private func setupGL() {
    context = EAGLContext(api: .openGLES3)
    EAGLContext.setCurrent(context)

    if let view = self.view as? GLKView, let context = context {
      view.context = context
      view.drawableDepthFormat = .format24
      view.drawableStencilFormat = .format8
    }

    setRenderer(renderer: renderer)
  }

  private func setRenderer(renderer: GLRenderer) {
    self.renderer = renderer
    self.renderer.delegate = self
    self.delegate = renderer
    renderer.setup()
  }

  private func setupSubviews() {
    view.addSubview(settingsButton)

    NSLayoutConstraint.activate([
      settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
    ])
  }

  @objc private func settingsButtonTapped() {
    let shaderListController = RenderersListViewController()
    shaderListController.output = self
    present(shaderListController, animated: true)
  }

  // MARK: - Gestures

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

// MARK: - GLRendererDelegate

extension GLViewController: GLRendererDelegate {
  func bindDrawableFramebuffer() {
    (view as? GLKView)?.bindDrawable()
  }
}

// MARK: - RenderersListViewControllerOutput

extension GLViewController: RenderersListViewControllerOutput {
  func didSelectRenderer(_ rendererModel: GLRendererModel) {
    setRenderer(renderer: rendererModel.buildClosure())
  }
}

