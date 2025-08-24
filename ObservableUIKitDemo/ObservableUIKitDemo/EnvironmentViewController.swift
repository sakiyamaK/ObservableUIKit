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
    @Entry var fontColor: UIColor = .systemRed
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

    // 環境変数の値をパラメータと連結
    @UIKitEnvironment(\.fontColor) var fontColorValue

    init () {
        super.init(frame: .null)

        layout()
        setValue()
    }

    private func layout() {

        self.addSubview(self.label)
        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: self.topAnchor),
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: self.label.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: self.label.bottomAnchor),
        ])

        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
    }

    private func setValue() {
        // 環境変数と連結したパラメータから値を取得
        self.label.tracking($fontColorValue, to: \.textColor)
    }
}

final class EnvironmentViewController: UIViewController {

    deinit {
        print("EnvironmentViewController deinit")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    private let customView: CustomView = {
        let customView = CustomView()
        customView.translatesAutoresizingMaskIntoConstraints = false
        return customView
    }()
    private let label: UILabel = {
        let label = UILabel(frame: .null)
        label.text = "EnvironmentViewControllerの中の文字列だよ"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var fontColorChangeButton: UIButton = {
        UIButton(configuration: .plain(), primaryAction: .init(title: "タップして文字色を変える", handler: {[weak self] _ in

            self!.fontColorValue = switch self!.fontColorValue {
            case .systemRed:
                    .systemCyan
            case .systemCyan:
                    .systemGreen
            case .systemGreen:
                    .systemRed
            default:
                    .systemRed
            }
        }))
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // 環境変数に登録するパラメータ
    @UIKitState private var fontColorValue = EnvironmentValues().fontColor
    // 環境変数の値をパラメータと連結
    @UIKitEnvironment(\.colorScheme) var colorSchemeValue


    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setValue()
    }

    private func layout() {
        self.view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])

        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(customView)
        stackView.setCustomSpacing(30, after: customView)
        stackView.addArrangedSubview(fontColorChangeButton)
    }

    private func setValue() {
        self.view
            // 環境変数と連動したパラメータから値を取得
            .tracking($colorSchemeValue) { view, colorScheme in
                if colorScheme == .dark {
                    view.backgroundColor = .systemGray
                } else {
                    view.backgroundColor = .systemBackground
                }
            }
            // 環境変数にパラメータを登録
            .environment(\.fontColor, state: _fontColorValue)

        // 環境変数と連動したパラメータから値を取得
        self.label
            .tracking($fontColorValue, to: \.textColor)

    }
}


#Preview {
    EnvironmentViewController()
        .environment(\.colorScheme, value: .dark)
}
