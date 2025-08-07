//
//  EnvironmentViewController.swift
//  ObservableUIKitDemo
//
//  Created by sakiyamaK on 2025/08/06.
//

import UIKit
import ObservableUIKit

// SwiftUIのオリジナルの環境変数を普通に用意
import SwiftUI
extension EnvironmentValues {
    @Entry var fontColor: UIColor = .black
}

// 環境変数から値を取得するカスタムビュー
final class CustomView: UIView {
    deinit {
        print("CustomView deinit")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let label: UILabel = {
        let label = UILabel(frame: .null)
        label.text = "カスタムビューの中の文字列だよ"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init () {
        super.init(frame: .null)

        layout()
        setValue()
    }

    private func layout() {
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: label.bottomAnchor),
        ])
    }

    private func setValue() {
        // 環境変数から値を取得
        label.read(environment: \.fontColor, to: \.textColor)
    }
}

final class EnvironmentViewController: UIViewController {
    deinit {
        print("EnvironmentViewController deinit")
    }
    // 環境変数から値を取得するLabel
    private let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "EnvironmentViewControllerの中の文字列だよ"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // 内部のLabelが環境変数から値を取得するCustomView
    private let customView: CustomView = {
        let customView = CustomView()
        customView.translatesAutoresizingMaskIntoConstraints = false
        return customView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
        setValue()
        update()
    }
    private func layout() {
        self.view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
    }

    // 環境変数に登録する値
    @UIKitState private var fontColorValue: UIColor = .black

    private func setValue() {

        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(customView)

        // 親Viewに環境変数の初期値をセット
        stackView
            .environment(\.fontColor, self._fontColorValue)

        // 環境変数から値を読み込む
        label.read(environment: \.fontColor, to: \.textColor)
    }
    // 監視対象のデータを更新
    private func update() {
        Task {

            try await Task.sleep(for: .seconds(1.0))

            fontColorValue = .systemRed

            try await Task.sleep(for: .seconds(1.0))

            fontColorValue = .systemBlue

            try await Task.sleep(for: .seconds(1.0))

            fontColorValue = .systemGreen
        }
    }
}

#Preview {
    UINavigationController(rootViewController: EnvironmentViewController())
}
