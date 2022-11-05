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
  private var rendererModel = GLRenderer.initialRendererModel
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

  private lazy var sensitivitySlider: UISlider = {
    let slider = UISlider()
    slider.isHidden = true
    slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    slider.translatesAutoresizingMaskIntoConstraints = false
    return slider
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupGL()
    setupSubviews()
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    renderer?.orientationChanged(UIDevice.current.orientation.isPortrait)
  }

  private func setupGL() {
    context = EAGLContext(api: .openGLES3)
    EAGLContext.setCurrent(context)

    if let view = self.view as? GLKView, let context = context {
      view.context = context
      view.drawableDepthFormat = .format24
      view.drawableStencilFormat = .format8
    }

    setRenderer(rendererModel: rendererModel)
  }

  private func setRenderer(rendererModel: GLRendererModel) {
    self.rendererModel = rendererModel
    renderer = rendererModel.buildClosure()
    renderer?.delegate = self
    delegate = renderer
    renderer?.setup()

    imagePickerButton.isHidden = !rendererModel.isImagePickerAvailable
    sensitivitySlider.isHidden = !rendererModel.isSensitivitySliderAvailable
  }

  private func setupSubviews() {
    view.addSubview(settingsButton)
    view.addSubview(imagePickerButton)
    view.addSubview(sensitivitySlider)

    NSLayoutConstraint.activate([
      settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
      settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

      imagePickerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
      imagePickerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

      sensitivitySlider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
      sensitivitySlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
      sensitivitySlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
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
    config.selectionLimit = rendererModel.imagePickerMaxImages

    let pickerController = PHPickerViewController(configuration: config)
    pickerController.delegate = self
    present(pickerController, animated: true)
  }

  @objc private func sliderValueChanged(_ slider: UISlider) {
    renderer?.changeSensitivity(slider.value)
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

  func setInitialSensitivitySliderValue(_ value: Float) {
    sensitivitySlider.value = value
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

    var textures: [GLTexture] = []

    results.map(\.itemProvider)
      .filter { $0.canLoadObject(ofClass: UIImage.self) }
      .forEach {
        group.enter()
        $0.loadObject(ofClass: UIImage.self) { (image, error) in
          guard let image = image as? UIImage else {
            group.leave()
            return
          }
          textures.append(GLTexture(image: image))
          group.leave()
        }
        group.wait()
      }

    renderer?.changeTextures(textures)
    picker.dismiss(animated: true)
  }
}

