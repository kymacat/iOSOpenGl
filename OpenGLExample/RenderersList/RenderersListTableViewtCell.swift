//
//  ShadersListTableViewtCell.swift
//  OpenGLExample
//
//  Created by Vladislav Yandola on 30.10.2022.
//

import UIKit

class RenderersListTableViewCell: UITableViewCell {
  static let reuseIdentifier = "shadersListTableViewCell"

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSubviews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(title: String) {
    textLabel?.text = title
  }

  private func setupSubviews() {
    backgroundColor = .black
    textLabel?.numberOfLines = 0
    textLabel?.textColor = .white
  }
}
