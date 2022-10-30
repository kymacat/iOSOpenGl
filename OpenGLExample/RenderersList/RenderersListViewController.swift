//
//  ShaderChooserViewController.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 30.10.2022.
//

import UIKit

class RenderersListViewController: UIViewController {
  private let renderers = GLRenderer.allRenderers

  weak var output: RenderersListViewControllerOutput?

  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .black
    tableView.separatorColor = .darkGray
    tableView.register(RenderersListTableViewCell.self, forCellReuseIdentifier: RenderersListTableViewCell.reuseIdentifier)
    tableView.translatesAutoresizingMaskIntoConstraints = false

    tableView.dataSource = self
    tableView.delegate = self
    return tableView
  }()

  init() {
    super.init(nibName: nil, bundle: nil)
    setupSubviews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupSubviews() {
    view.addSubview(tableView)

    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}

// MARK: - UITableViewDataSource

extension RenderersListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    renderers.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: RenderersListTableViewCell.reuseIdentifier,
      for: indexPath
    ) as? RenderersListTableViewCell
    else {
      return UITableViewCell()
    }

    cell.configure(title: renderers[indexPath.row].title)

    return cell
  }
}

// MARK: - UITableViewDelegate

extension RenderersListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    output?.didSelectRenderer(renderers[indexPath.row])
    dismiss(animated: true)
  }
}
