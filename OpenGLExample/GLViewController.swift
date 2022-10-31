//
//  ViewController.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 04.10.2022.
//

import UIKit
import GLKit
import PhotosUI

class GLViewController: GLKViewController {
  private var context: EAGLContext?
  private var renderer: GLRenderer?

  private lazy var settingsButton: UIButton = {
    let button = UIButton(type: .system)
    button.tintColor = .white
    button.setImage(.init(systemName: "gearshape"), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
    return button
  }()

  private lazy var imagePickerButton: UIButton = {
    let button = UIButton(type: .system)
    button.tintColor = .white
    button.isHidden = true
    button.setImage(.init(systemName: "square.and.arrow.up"), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(imagePickerButtonTapped), for: .touchUpInside)
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

    setRenderer(rendererModel: GLRenderer.initialRendererModel)
  }

  private func setRenderer(rendererModel: GLRendererModel) {
    renderer = rendererModel.buildClosure()
    renderer?.delegate = self
    delegate = renderer
    renderer?.setup()

    imagePickerButton.isHidden = !rendererModel.isImagePickerAvailable
  }

  private func setupSubviews() {
    view.addSubview(settingsButton)
    view.addSubview(imagePickerButton)

    NSLayoutConstraint.activate([
      settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

      imagePickerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      imagePickerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)
    ])
  }

  // MARK: - Actions

  @objc private func settingsButtonTapped() {
    let shaderListController = RenderersListViewController()
    shaderListController.output = self
    present(shaderListController, animated: true)
  }

  @objc private func imagePickerButtonTapped() {
    var config = PHPickerConfiguration()
    config.filter = .images

    let pickerController = PHPickerViewController(configuration: config)
    pickerController.delegate = self
    present(pickerController, animated: true)
  }

  // MARK: - Gestures

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    renderer?.touchesBegan(touches, in: view)
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    renderer?.touchesMoved(touches, in: view)
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    renderer?.touchesEnded(touches, in: view)
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
    setRenderer(rendererModel: rendererModel)
  }
}

// MARK: - PHPickerViewControllerDelegate

extension GLViewController: PHPickerViewControllerDelegate {
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    let group = DispatchGroup()

    var images: [UIImage] = []

    results.map(\.itemProvider)
      .filter { $0.canLoadObject(ofClass: UIImage.self) }
      .forEach {
        group.enter()
        $0.loadObject(ofClass: UIImage.self) { (image, error) in
          guard let image = image as? UIImage else {
            group.leave()
            return
          }
          images.append(image)
          group.leave()
        }
        group.wait()
      }

    renderer?.changeTextures(with: images)
    picker.dismiss(animated: true)
  }
}

